# Created RDS Global Cluster with 1 instance in us-east-1
# Didnt created secondary instance since, it needs to have vpc, nat in other region too

# provider blocks with alias to create in multiple regions
# provider block for primary(us-east-1) region
provider "aws" {
  alias   = "primary"
  region  = "us-east-1"
  profile = "AdministratorAccess-912388441087"
}

# provider block for secondary(us-west-1) region
provider "aws" {
  alias   = "secondary"
  region  = "us-west-1"
  profile = "AdministratorAccess-912388441087"
}

# RDS Global cluster
resource "aws_rds_global_cluster" "rds" {
  global_cluster_identifier = var.cluster_name
  engine                    = "aurora-postgresql"
  engine_version            = var.db_version
  database_name             = var.db_name

}

# Need to have DB subnet group to attach to the cluster
# if had secondary region, then subnet group needs to be created in secondary region too
resource "aws_db_subnet_group" "dsg" {
  name       = "primary-subnet-group"
  subnet_ids = [for subnet in aws_subnet.prvt : subnet.id]
}

# RDS primary POSTGRESQL cluster
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

# RDS primary cluster instance
resource "aws_rds_cluster_instance" "primary" {
  provider             = aws.primary
  engine               = aws_rds_global_cluster.rds.engine
  engine_version       = aws_rds_global_cluster.rds.engine_version
  identifier           = "${aws_rds_cluster.primary.cluster_identifier}-instance"
  cluster_identifier   = aws_rds_cluster.primary.id
  instance_class       = var.db_instance_type
  db_subnet_group_name = aws_db_subnet_group.dsg.name
}

