terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

# Using IAM Roles instead of access keys
# Stored in .aws/config file
provider "aws" {
  region  = "us-east-1"
  profile = "AdministratorAccess-912388441087"
}