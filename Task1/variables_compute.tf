# Create ALB if Name is not NA or empty
variable "alb_name" {
  type        = string
  description = "Name of the ALB"

  validation {
    condition     = lower(var.alb_name) != "na" || lenght(var.alb_name) != 0
    error_message = "ALB Name cannot be empty or NA"
  }
}

# Validate if AMI id start with 'ami-'
variable "ami_id" {
  type        = string
  description = "AMI Id of the EC2 instance"

  validation {
    condition     = can(regex("^ami\\-*", var.ami_id))
    error_message = "AMI Id is not valid"
  }
}

# validate if instance type starts with t or m series
variable "instance_type" {
  type        = string
  description = "Instance Type of EC2 Instance"

  validation {
    condition     = can(regex("^t[0-9]\\.[a-z]*$", var.instance_type)) || can(regex("^m[0-9]\\.[a-z]*$", var.instance_type))
    error_message = "Instance type can only be General Purposed (t or m family)"
  }
}