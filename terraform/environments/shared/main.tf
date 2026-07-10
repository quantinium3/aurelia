module "ecr" {
  source = "../../module/ecr"

  repository_names = var.repository_names
  tags             = var.tags
}
