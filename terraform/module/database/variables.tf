variable "name" {
  description = "The identifier for the RDS instance"
  type        = string
}

variable "instance_class" {
  description = "The instance class for the RDS instance"
  type        = string
}

variable "db_name" {
  description = "The name of the database to create"
  type        = string
}

variable "db_username" {
  description = "The master username for the database"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to deploy the database into"
  type        = string
}

variable "database_subnets" {
  description = "The subnet IDs to use for the DB subnet group"
  type        = list(string)
}

variable "node_security_group_id" {
  description = "The security group ID of the EKS cluster nodes, allowed to reach the database"
  type        = string
}

variable "multi_az" {
  description = "Whether to deploy a multi-AZ standby replica for the database"
  type        = bool
}

variable "deletion_protection" {
  description = "Whether to enable deletion protection on the database"
  type        = bool
}

variable "skip_final_snapshot" {
  description = "Whether to skip taking a final snapshot when the database is destroyed"
  type        = bool
}

variable "tags" {
  description = "The tags related to the database"
  type        = map(string)
}
