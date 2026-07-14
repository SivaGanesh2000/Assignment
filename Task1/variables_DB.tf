variable "cluster_name" {
  type        = string
  description = "Name of the RDS Global Cluster"
  nullable    = false
}

variable "db_version" {
  type        = string
  description = "PostgreSql Database Version"
  nullable    = false
}

variable "db_name" {
  type        = string
  description = "Name of the Database"
}

variable "db_username" {

  type        = string
  description = "Master Username to login to DB"

}

variable "db_password" {
  type        = string
  description = "Master Password to login to DB"
  sensitive   = true
}

variable "db_instance_type" {
  type        = string
  description = "Instance class for the DB instance"
}