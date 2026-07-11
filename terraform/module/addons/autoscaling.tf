resource "helm_release" "metrics_server" {
  count = var.enable_autoscaling ? 1 : 0

  name       = "metrics-server"
  repository = "https://kubernetes-sigs.github.io/metrics-server"
  chart      = "metrics-server"
  namespace  = "kube-system"
}

module "cluster_autoscaler_pod_identity" {
  count = var.enable_autoscaling ? 1 : 0

  source  = "terraform-aws-modules/eks-pod-identity/aws"
  version = "~> 2.8"

  name = "${var.cluster_name}-cluster-autoscaler"

  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_names = [var.cluster_name]

  associations = {
    this = {
      cluster_name    = var.cluster_name
      namespace       = "kube-system"
      service_account = "cluster-autoscaler"
    }
  }

  tags = var.tags
}

resource "helm_release" "cluster_autoscaler" {
  count = var.enable_autoscaling ? 1 : 0

  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  namespace  = "kube-system"

  set = [
    {
      name  = "autoDiscovery.clusterName"
      value = var.cluster_name
    },
    {
      name  = "awsRegion"
      value = var.region
    },
    {
      name  = "rbac.serviceAccount.name"
      value = "cluster-autoscaler"
    }
  ]
}
