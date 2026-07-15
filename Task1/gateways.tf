# Created NAT for instances in private subnet
# Created Internet Gateway for instances in public subnet

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = merge({
    "Name" = "${aws_vpc.vpc.tags["Name"]}-VPC-IGW"
  })
}

resource "aws_nat_gateway" "name" {
  vpc_id            = aws_vpc.vpc.id
  availability_mode = "regional"

  tags = merge({
    "Name" = "${aws_vpc.vpc.tags["Name"]}-Nat-Gateway"
  })
}