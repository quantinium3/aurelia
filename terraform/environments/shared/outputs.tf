output "repository_urls" {
  value = module.ecr.repository_urls
}

output "github_actions_role_arn" {
  value = module.github_actions.role_arn
}
