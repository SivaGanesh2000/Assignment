provider "aws" {
  alias   = "primary"
  region  = "us-east-1"
  profile = "AdministratorAccess-912388441087"
}

provider "aws" {
  alias   = "secondary"
  region  = "us-west-1"
  profile = "AdministratorAccess-912388441087"
}

resource "aws_rds_global_cluster" "rds" {
  global_cluster_identifier = var.cluster_name
  engine                    = "aurora-postgresql"
  engine_version            = var.db_version
  database_name             = var.db_name

}

resource "aws_db_subnet_group" "dsg" {
  name       = "primary-subnet-group"
  subnet_ids = [for subnet in aws_subnet.prvt : subnet.id]
}

resource "aws_rds_cluster" "primary" {
  provider                  = aws.primary
  global_cluster_identifier = aws_rds_global_cluster.rds.id
  engine                    = aws_rds_global_cluster.rds.engine
  engine_version            = aws_rds_global_cluster.rds.engine_version

  cluster_identifier     = "${aws_rds_global_cluster.rds.global_cluster_identifier}primary"
  master_username        = var.db_username
  master_password        = var.db_password
  skip_final_snapshot    = true
  database_name          = "${aws_rds_global_cluster.rds.database_name}primary"
  db_subnet_group_name   = aws_db_subnet_group.dsg.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
}

resource "aws_rds_cluster_instance" "primary" {
  provider             = aws.primary
  engine               = aws_rds_global_cluster.rds.engine
  engine_version       = aws_rds_global_cluster.rds.engine_version
  identifier           = "${aws_rds_cluster.primary.cluster_identifier}-instance"
  cluster_identifier   = aws_rds_cluster.primary.id
  instance_class       = var.db_instance_type
  db_subnet_group_name = aws_db_subnet_group.dsg.name
}

