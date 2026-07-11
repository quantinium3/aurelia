output "vpc_id" {
  value = module.network.vpc_id
}

output "cluster_name" {
  value = module.cluster.cluster_name
}

output "cluster_endpoint" {
  value = module.cluster.cluster_endpoint
}

output "node_security_group_id" {
  value = module.cluster.node_security_group_id
}

output "db_instance_endpoint" {
  value = module.database.db_instance_endpoint
}

output "db_instance_master_user_secret_name" {
  value = module.database.db_instance_master_user_secret_name
}

output "cache_address" {
  value = module.elasticache.cluster_address
}

output "cloudfront_domain_name" {
  value = try(module.frontend_edge[0].cloudfront_domain_name, null)
}

output "alb_origin_certificate_arn" {
  value = try(module.frontend_edge[0].origin_certificate_arn, null)
}

output "frontend_alb_security_group_id" {
  value = try(module.frontend_edge[0].alb_security_group_id, null)
}

output "vpn_client_vpn_endpoint_id" {
  value = module.vpn.client_vpn_endpoint_id
}
