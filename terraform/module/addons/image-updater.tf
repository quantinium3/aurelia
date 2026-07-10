data "aws_caller_identity" "current" {}

module "image_updater_pod_identity" {
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "~> 2.8"

  name = "${var.cluster_name}-image-updater"

  attach_custom_policy = true
  policy_statements = [
    {
      sid       = "ECRAuth"
      actions   = ["ecr:GetAuthorizationToken"]
      resources = ["*"]
    },
    {
      sid = "ECRRead"
      actions = [
        "ecr:DescribeRepositories",
        "ecr:DescribeImages",
        "ecr:ListImages",
        "ecr:ListTagsForResource",
        "ecr:BatchGetImage",
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
      ]
      resources = ["*"]
    }
  ]

  associations = {
    this = {
      cluster_name    = var.cluster_name
      namespace       = "argocd"
      service_account = "argocd-image-updater"
    }
  }

  tags = var.tags
}

resource "helm_release" "argocd_image_updater" {
  name             = "argocd-image-updater"
  repository       = "https://argoproj.github.io/argo-helm"
  chart            = "argocd-image-updater"
  namespace        = "argocd"
  create_namespace = false

  values = [
    yamlencode({
      config = {
        "git.user"  = "argocd-image-updater"
        "git.email" = "argocd-image-updater@aurelia.local"
        registries = [
          {
            name        = "ECR"
            api_url     = "https://${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com"
            prefix      = "${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.region}.amazonaws.com"
            ping        = true
            insecure    = false
            credentials = "ext:/scripts/ecr-auth.sh"
            credsexpire = "10h"
          }
        ]
      }
      authScripts = {
        enabled = true
        scripts = {
          "ecr-auth.sh" = "#!/bin/sh\necho \"AWS:$(aws ecr get-login-password --region ${var.region})\"\n"
        }
      }
    })
  ]
}
