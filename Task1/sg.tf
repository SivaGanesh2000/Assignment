## ALB Security Group

## SG for ALB
resource "aws_security_group" "alb_sg" {
  name        = "alb_sg"
  description = "Allow http inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "alb_sg"
  }
}

# Allow Http access from ALB SG
resource "aws_vpc_security_group_ingress_rule" "allow_http" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

# Allow all outbound traffic from ALB Security Group
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = aws_security_group.alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

## EC2 Security Group
resource "aws_security_group" "ec2_sg" {
  name        = "EC2_SG"
  description = "Allow http inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "EC2_SG"
  }
}

# Allow Http access from ALB SG within EC2 SG
resource "aws_vpc_security_group_ingress_rule" "ec2_in" {
  security_group_id            = aws_security_group.ec2_sg.id
  referenced_security_group_id = aws_security_group.alb_sg.id
  from_port                    = 80
  ip_protocol                  = "tcp"
  to_port                      = 80
}

# Allow all outbound traffic from EC2 Security Group
resource "aws_vpc_security_group_egress_rule" "ec2_out" {
  security_group_id = aws_security_group.ec2_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

## RDS Security Group 
resource "aws_security_group" "rds_sg" {
  name        = "RDS_Sg"
  description = "Allow http inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "RDS_SG"
  }
}

# Allow PostgreSql access from EC2 SG within PostgreSql SG
resource "aws_vpc_security_group_ingress_rule" "rds_in" {
  security_group_id            = aws_security_group.rds_sg.id
  referenced_security_group_id = aws_security_group.ec2_sg.id
  from_port                    = 5432
  ip_protocol                  = "tcp"
  to_port                      = 5432
}

# Allow all outbound traffic from PostgreSql Security Group
resource "aws_vpc_security_group_egress_rule" "rds_out" {
  security_group_id = aws_security_group.rds_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}