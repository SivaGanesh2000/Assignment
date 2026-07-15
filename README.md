## Overview
This Terraform configuration provisions a Three-Tier Architecture with public-facing AWS Application Load Balancer (ALB) to allow frontend access over HTTP (port 80),
with EC2 instance behind ALB in private subnet, which talks with RDS instance in Private Subnet.


### Prerequisites
Terraform v1.x installed locally.

AWS CLI configured with valid credentials (aws configure).

Proper IAM permissions to create

### Variables
The configuration expects few variables which are listed in 'variables.tf' file an example is provided with name 'dev.auto.tfvars'

### Usage
Initialize Terraform:
```bash
terraform init
```
Review the execution plan:

```bash
terraform plan
```
Apply the configuration:

```bash
terraform apply
```

### Validation
After deployment:

Confirm the ALB is created in the AWS console under EC2 → Load Balancers.

Verify the security group allows inbound traffic on port 80.

Test by hitting the ALB’s DNS name:

```bash
curl http://<alb-dns-name>
```

### Cleanup
To destroy the resources:

```bash
terraform destroy
```
