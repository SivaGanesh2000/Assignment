## created route tables and attached them to subnets
# for public subnets added route to internet gateway for public traffic
# for private subnets added route to nat for public traffic

# Public Route Table
resource "aws_route_table" "pblc_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    "Name" = "Public-Route-Table"
  }
}

# Private Route Table
resource "aws_route_table" "prvt_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.name.id
  }

  tags = {
    "Name" = "Private-Route-Table"
  }
}

# Associate Public Subnet Route Table to all Public Subnets
resource "aws_route_table_association" "pblc_rta" {
  count          = length(aws_subnet.pblc)
  route_table_id = aws_route_table.pblc_rt.id
  subnet_id      = aws_subnet.pblc[count.index].id
}

# Associate Private Subnet Route Table to all Private Subnets
resource "aws_route_table_association" "prvt_rta" {
  count          = length(aws_subnet.prvt)
  route_table_id = aws_route_table.prvt_rt.id
  subnet_id      = aws_subnet.prvt[count.index].id
}