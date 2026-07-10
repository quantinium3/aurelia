output "role_arn" {
  description = "The ARN of the IAM role GitHub Actions assumes to push images to ECR"
  value       = module.github_actions_role.arn
}
