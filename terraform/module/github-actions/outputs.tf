output "role_arn" {
  description = "The ARN of the IAM role GitHub Actions assumes to push images to ECR"
  value       = module.github_actions_role.arn
}

output "terraform_role_arn" {
  description = "The ARN of the IAM role GitHub Actions assumes to run Terraform (master branch only)"
  value       = module.terraform_role.arn
}
