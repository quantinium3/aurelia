module "cloudwatch_observability_pod_identity" {
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "~> 2.8"

  name = "${var.cluster_name}-cloudwatch-observability"

  attach_aws_cloudwatch_observability_policy = true

  associations = {
    this = {
      cluster_name    = var.cluster_name
      namespace       = "amazon-cloudwatch"
      service_account = "cloudwatch-agent"
    }
  }

  tags = var.tags
}

resource "helm_release" "cloudwatch_observability" {
  name             = "amazon-cloudwatch-observability"
  repository       = "https://aws-observability.github.io/helm-charts"
  chart            = "amazon-cloudwatch-observability"
  namespace        = "amazon-cloudwatch"
  create_namespace = true

  set = [
    {
      name  = "clusterName"
      value = var.cluster_name
    },
    {
      name  = "region"
      value = var.region
    }
  ]
}
