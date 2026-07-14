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


resource "aws_route_table_association" "pblc_rta" {
  count          = length(aws_subnet.pblc)
  route_table_id = aws_route_table.pblc_rt.id
  subnet_id      = aws_subnet.pblc[count.index].id
}


resource "aws_route_table_association" "prvt_rta" {
  count          = length(aws_subnet.prvt)
  route_table_id = aws_route_table.prvt_rt.id
  subnet_id      = aws_subnet.prvt[count.index].id
}