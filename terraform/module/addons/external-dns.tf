module "external_dns_pod_identity" {
  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "~> 2.8"

  name = "${var.cluster_name}-external-dns"

  attach_custom_policy = true
  policy_statements = [
    {
      sid = "Route53RecordChanges"
      actions = [
        "route53:ChangeResourceRecordSets",
        "route53:ListResourceRecordSets",
        "route53:ListTagsForResources",
      ]
      resources = ["arn:aws:route53:::hostedzone/${var.public_hosted_zone_id}"]
    },
    {
      sid       = "Route53ZoneList"
      actions   = ["route53:ListHostedZones"]
      resources = ["*"]
    }
  ]

  associations = {
    this = {
      cluster_name    = var.cluster_name
      namespace       = "external-dns"
      service_account = "external-dns"
    }
  }

  tags = var.tags
}

resource "helm_release" "external_dns" {
  name             = "external-dns"
  repository       = "https://kubernetes-sigs.github.io/external-dns/"
  chart            = "external-dns"
  namespace        = "external-dns"
  create_namespace = true

  values = [
    yamlencode({
      provider      = { name = "aws" }
      aws           = { zoneType = "public" }
      domainFilters = [var.public_domain_name]
      # upsert-only: himanshusolo.dev has other manually-managed records outside
      # this project; external-dns should never delete records it doesn't own.
      policy     = "upsert-only"
      txtOwnerId = "aurelia"
      sources    = ["ingress"]
      serviceAccount = {
        create = true
        name   = "external-dns"
      }
    })
  ]
}
