module "redis" {
  source  = "terraform-aws-modules/elasticache/aws"
  version = "~> 1.11"

  cluster_id               = var.cluster_id
  create_cluster           = !var.create_replication_group
  create_replication_group = var.create_replication_group

  engine          = "redis"
  engine_version  = var.engine_version
  node_type       = var.node_type
  num_cache_nodes = var.num_cache_nodes

  at_rest_encryption_enabled = true
  transit_encryption_enabled = var.transit_encryption_enabled
  auth_token                 = var.transit_encryption_enabled ? var.auth_token : null

  vpc_id = var.vpc_id
  security_group_rules = {
    ingress_node_sg = {
      description                  = "Redis access from EKS nodes"
      referenced_security_group_id = var.node_security_group_id
    }
  }

  subnet_ids = var.elasticache_subnets
  tags       = var.tags
}
