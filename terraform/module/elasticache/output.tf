output "cluster_address" {
  description = "DNS name of the cache cluster, used when create_replication_group is false"
  value       = module.redis.cluster_address
}

output "replication_group_primary_endpoint_address" {
  description = "Address of the replication group's primary node, used when create_replication_group is true"
  value       = module.redis.replication_group_primary_endpoint_address
}

output "security_group_id" {
  description = "The ID of the security group attached to the cache"
  value       = module.redis.security_group_id
}
