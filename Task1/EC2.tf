# A role already exists, hence pulling it from AWS Console
data "aws_iam_role" "ec2_role" {
  name = "InstanceRole"
}

# We cannot directly assign a role to the instance.
# Hence creating iam instance profile.

resource "aws_iam_instance_profile" "ec2_profile" {
  name = "instance-profile"
  role = data.aws_iam_role.ec2_role.name
}

# Creates an EC2 instance with given instance type
# Disable Public IP
# Create in Private Subnet
# Attaching IAM Profile for trouble shooting
# Attached a file which installs and starts nginx, just for testing the flow of abl to ec2

resource "aws_instance" "ec2" {
  ami           = var.ami_id
  instance_type = var.instance_type

  associate_public_ip_address = false
  subnet_id                   = aws_subnet.prvt[0].id

  iam_instance_profile   = aws_iam_instance_profile.ec2_profile.name
  key_name               = "Quanteon"
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = file("nginx.sh")

  tags = { "Name" = "Quanteon-Instance" }

  depends_on = [
    aws_nat_gateway.name
  ]
}