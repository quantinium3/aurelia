variable "name_prefix" {
  description = "Prefix for named resources, e.g. aurelia-dev or aurelia-prod"
  type        = string
}

variable "notification_email" {
  description = "Email address subscribed to the alarm SNS topic"
  type        = string
}

variable "db_identifier" {
  description = "RDS instance identifier used as the DBInstanceIdentifier alarm dimension"
  type        = string
}

variable "db_instance_id" {
  description = "RDS instance id (DBInstanceIdentifier dimension value)"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name, used to discover the frontend ALB by its elbv2.k8s.aws/cluster tag"
  type        = string
}

variable "rds_free_storage_threshold_bytes" {
  description = "Free storage alarm threshold in bytes"
  type        = number
  default     = 2147483648
}

variable "tags" {
  description = "Tags applied to created resources"
  type        = map(string)
}
