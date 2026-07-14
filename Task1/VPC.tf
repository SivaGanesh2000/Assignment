resource "aws_vpc" "vpc" {
  cidr_block = var.vpc_cidr

  tags = merge({
    "Name"        = "Terraform-VPC",
    "Description" = "Created using Terraform"
  }, var.vpc_tags)
}