output "db_instance_endpoint" {
  description = "The connection endpoint for the database, in address:port format"
  value       = module.rds.db_instance_endpoint
}

output "db_instance_address" {
  description = "The address of the database, without the port"
  value       = module.rds.db_instance_address
}

output "db_instance_master_user_secret_arn" {
  description = "The ARN of the Secrets Manager secret holding the master user password"
  value       = aws_secretsmanager_secret.master_password.arn
}

output "db_instance_master_user_secret_name" {
  description = "The stable name of the Secrets Manager secret holding the master user password"
  value       = aws_secretsmanager_secret.master_password.name
}

output "security_group_id" {
  description = "The ID of the security group attached to the database"
  value       = module.security_group.security_group_id
}
