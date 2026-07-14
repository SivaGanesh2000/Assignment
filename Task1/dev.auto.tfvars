#Compute Variables
alb_name      = "Quanteon-ALB"
ami_id        = "ami-0b6d9d3d33ba97d99"
instance_type = "t3.medium"

# DB Variables
cluster_name     = "quanteondbcluster"
db_version       = "16.4"
db_name          = "QuanteonGlobalDB"
db_username      = "Quanteon"
db_password      = "Qu#nt30n"
db_instance_type = "db.r7g.large"

# Network Variables
vpc_cidr             = "10.0.0.0/16"
vpc_tags             = { "Name" = "Quanteon-VPC" }
public_subnet_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnet_tags   = { "Name" = "Quanteon-Public-Subnet" }
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
private_subnet_tags  = { "Name" = "Quanteon-Private-Subnet" }
subnet_az            = ["us-east-1a", "us-east-1b"]