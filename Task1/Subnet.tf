# Creates a list of both Public and Private Subnets, provided CIDR ranges

# List of Public Subnet Resources
resource "aws_subnet" "pblc" {
  vpc_id = aws_vpc.vpc.id
  count  = length(var.public_subnet_cidrs)

  cidr_block        = var.public_subnet_cidrs[count.index]
  availability_zone = var.subnet_az[count.index]

  tags = merge(var.public_subnet_tags, {
    "Name" = length(var.public_subnet_tags["Name"]) > 0 ? "${var.public_subnet_tags["Name"]}-${count.index + 1}" : "Terraform-Public-Subnet-${count.index + 1}",
  })
}

# List of Private Subnet Resources
resource "aws_subnet" "prvt" {
  vpc_id = aws_vpc.vpc.id
  count  = length(var.private_subnet_cidrs)

  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.subnet_az[count.index]

  tags = merge(var.private_subnet_tags, {
    "Name" = length(var.private_subnet_tags["Name"]) > 0 ? "${var.private_subnet_tags["Name"]}-${count.index + 1}" : "Terraform-Private-Subnet-${count.index}",
  })
}