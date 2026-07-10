module "ecr" {
  source = "../../module/ecr"

  repository_names = var.repository_names
  tags             = var.tags
}

module "github_actions" {
  source = "../../module/github-actions"

  name                = "aurelia"
  github_repo         = var.github_repo
  ecr_repository_arns = values(module.ecr.repository_arns)

  tags = var.tags
}
