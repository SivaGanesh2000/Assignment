output "VPC" {
  value = { "Id" = aws_vpc.vpc.id,
    "Arn"              = aws_vpc.vpc.arn,
    "Instance_Tenancy" = aws_vpc.vpc.instance_tenancy
    "Tags"             = aws_vpc.vpc.tags
  }
}

output "EC2" {
  value = { "Instance_Id" = aws_instance.ec2.id,
    "Instance_Name" = aws_instance.ec2.tags["Name"]
    "Private_IP" = aws_instance.ec2.private_ip
    "Instance_Role" = data.aws_iam_role.ec2_role.name
    "Security_Groups" = aws_instance.ec2.vpc_security_group_ids
  }
}

output "RDS" {
  value = {
    "DB_Instance" = aws_rds_cluster_instance.primary.id
    "Security_Group_Ids" = aws_rds_cluster.primary.vpc_security_group_ids
    "DB_Engine" = aws_rds_cluster.primary.engine
    "DB_Engine_Version" = aws_rds_cluster.primary.engine_version
  }
}

output "ALB" {
  value = {
    "ALB" = aws_lb.alb.name
    "DNS" = aws_lb.alb.dns_name
    "ALB_SG_Ids" = aws_lb.alb.security_groups
    "LB_Type" = aws_lb.alb.load_balancer_type
  }
}