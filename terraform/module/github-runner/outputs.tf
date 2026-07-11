output "instance_id" {
  description = "EC2 instance ID of the runner"
  value       = aws_instance.runner.id
}

output "security_group_id" {
  description = "Security group ID of the runner"
  value       = aws_security_group.runner.id
}
