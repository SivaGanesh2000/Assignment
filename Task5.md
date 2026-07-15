## My Request
can you create a Terraform module for a reusable 'secure-ec2' pattern: 
1. EC2 shoudl be in private subnet, 
2. Instance should have SSM access only (no SSH), 
3. CloudWatch agent pre-configured, 
4. IMDSv2 enforced.
---

## Copilot Response
Here’s a reusable Terraform module for a secure-ec2 pattern that enforces all the security requirements you listed:

``` hcl
# modules/secure-ec2/main.tf
variable "vpc_id" {}
variable "private_subnet_ids" {
  type = list(string)
}
variable "instance_type" {
  default = "t3.micro"
}
variable "ami_id" {}
variable "tags" {
  type    = map(string)
  default = {}
}

resource "aws_security_group" "ssm_only" {
  name        = "secure-ec2-sg"
  description = "No inbound SSH, allow SSM only"
  vpc_id      = var.vpc_id

  # No inbound rules (no SSH)
  ingress = []

  # Allow all outbound (needed for SSM agent to connect)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = var.tags
}

resource "aws_iam_role" "ec2_ssm_role" {
  name               = "secure-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume.json
}

data "aws_iam_policy_document" "ec2_assume" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ssm_managed" {
  role       = aws_iam_role.ec2_ssm_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ec2_ssm_profile" {
  name = "secure-ec2-profile"
  role = aws_iam_role.ec2_ssm_role.name
}

resource "aws_instance" "secure_ec2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = element(var.private_subnet_ids, 0)
  vpc_security_group_ids      = [aws_security_group.ssm_only.id]
  iam_instance_profile        = aws_iam_instance_profile.ec2_ssm_profile.name
  associate_public_ip_address = false

  metadata_options {
    http_tokens = "required"   # Enforce IMDSv2
  }

  user_data = <<-EOF
              #!/bin/bash
              # Install CloudWatch Agent
              yum install -y amazon-cloudwatch-agent
              cat <<EOC > /opt/aws/amazon-cloudwatch-agent/bin/config.json
              {
                "agent": {
                  "metrics_collection_interval": 60,
                  "logfile": "/opt/aws/amazon-cloudwatch-agent/logs/amazon-cloudwatch-agent.log"
                },
                "metrics": {
                  "append_dimensions": {
                    "InstanceId": "\${aws:InstanceId}"
                  },
                  "metrics_collected": {
                    "cpu": {
                      "measurement": [
                        "usage_idle",
                        "usage_system",
                        "usage_user"
                      ],
                      "metrics_collection_interval": 60
                    },
                    "disk": {
                      "measurement": [
                        "used_percent"
                      ],
                      "metrics_collection_interval": 60,
                      "resources": ["*"]
                    },
                    "mem": {
                      "measurement": [
                        "mem_used_percent"
                      ],
                      "metrics_collection_interval": 60
                    }
                  }
                }
              }
              EOC
              /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
                -a fetch-config -m ec2 -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json -s
              EOF

  tags = merge(var.tags, { Name = "secure-ec2" })
}
```
🔒 Key Security Features
Private subnet only → No public IP assigned.

No SSH access → Security group has no inbound rules; only outbound for SSM agent.

SSM Session Manager → IAM role with AmazonSSMManagedInstanceCore attached.

CloudWatch agent pre-configured → Installed and started via user_data.

IMDSv2 enforced → http_tokens = "required" ensures metadata service requires secure tokens.

This module can be dropped into your Terraform project and reused by passing in:

``` hcl
module "secure_ec2" {
  source             = "./modules/secure-ec2"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnets
  ami_id             = "ami-xxxxxxxx"
  tags               = { Environment = "prod" }
}
```
---

## Changes I would do

- Create a new variable for IAM Role instead of creating a resource, since we may have already existing IAM role
- Also, IAM role resource would be created every time the module is run which could cause issues, if same role exists with same name within an account.
- Put the User data contents in a \*.sh file and update the user_data field to file(\*.sh)
