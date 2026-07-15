variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC"

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "The provided value is not a valid CIDR"
  }
}

variable "vpc_tags" {
  type        = map(string)
  description = "Provide Tags for the VPC"

}

# list of Public Subnet Cidrs
variable "public_subnet_cidrs" {
  type        = list(string)
  description = "Provide list of public CIDR ranges"

  validation {
    condition     = alltrue([for cidr in var.public_subnet_cidrs : can(cidrnetmask(cidr))])
    error_message = "One of the CIDR range is not valid"
  }
}

# list of public subnets
variable "subnet_az" {
  type        = list(string)
  description = "AZ in which subnets needs to be launched"
}

variable "public_subnet_tags" {
  type        = map(string)
  description = "Tags for Public Subnet"
}

variable "private_subnet_cidrs" {
  type        = list(string)
  description = "Provide list of private CIDR ranges"

  validation {
    condition     = alltrue([for cidr in var.private_subnet_cidrs : can(cidrnetmask(cidr))])
    error_message = "One of the CIDR range is not valid"
  }
}

variable "private_subnet_tags" {
  type        = map(string)
  description = "Tags for the Private Subnet"
}