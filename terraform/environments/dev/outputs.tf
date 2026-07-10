output "vpc_id" {
  value = module.network.vpc_id
}

output "private_subnets" {
  value = module.network.private_subnets
}

output "database_subnets" {
  value = module.network.database_subnets
}

output "elasticache_subnets" {
  value = module.network.elasticache_subnets
}

output "cluster_name" {
  value = module.cluster.cluster_name
}

output "cluster_endpoint" {
  value = module.cluster.cluster_endpoint
}

output "oidc_provider_arn" {
  value = module.cluster.oidc_provider_arn
}

output "node_security_group_id" {
  value = module.cluster.node_security_group_id
}

output "db_instance_endpoint" {
  value = module.database.db_instance_endpoint
}

output "db_instance_master_user_secret_arn" {
  value = module.database.db_instance_master_user_secret_arn
}

output "db_instance_master_user_secret_name" {
  value = module.database.db_instance_master_user_secret_name
}

output "database_security_group_id" {
  value = module.database.security_group_id
}

output "cache_address" {
  value = module.elasticache.cluster_address
}

output "cache_security_group_id" {
  value = module.elasticache.security_group_id
}

output "vpn_client_vpn_endpoint_id" {
  value = module.vpn.client_vpn_endpoint_id
}

output "vpn_dns_name" {
  value = module.vpn.dns_name
}

output "frontend_certificate_arn" {
  value = aws_acm_certificate.frontend.arn
}
