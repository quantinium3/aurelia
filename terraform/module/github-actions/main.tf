module "ecr_push_policy" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-policy"
  version = "~> 6.0"

  name        = "${var.name}-ecr-push"
  description = "Allow pushing images to the aurelia ECR repositories"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid      = "ECRAuth"
        Effect   = "Allow"
        Action   = "ecr:GetAuthorizationToken"
        Resource = "*"
      },
      {
        Sid    = "ECRPush"
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:BatchGetImage",
        ]
        Resource = var.ecr_repository_arns
      }
    ]
  })

  tags = var.tags
}

module "github_oidc_provider" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-oidc-provider"
  version = "~> 6.0"

  url = "https://token.actions.githubusercontent.com"

  tags = var.tags
}

module "github_actions_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role"
  version = "~> 6.0"

  name = "${var.name}-github-actions"

  enable_github_oidc     = true
  oidc_wildcard_subjects = ["${var.github_repo}:*"]

  policies = {
    ecr_push = module.ecr_push_policy.arn
  }

  tags = var.tags
}

module "terraform_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role"
  version = "~> 6.0"

  name = "${var.name}-terraform"

  enable_github_oidc     = true
  oidc_wildcard_subjects = ["${var.github_repo}:ref:refs/heads/master"]

  policies = {
    admin = "arn:aws:iam::aws:policy/AdministratorAccess"
  }

  tags = var.tags
}
