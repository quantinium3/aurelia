output "cluster_address" {
  description = "DNS name of the cache cluster, used when create_replication_group is false. cluster_address itself is Memcached-only, so for Redis this reads the address off the first (and only) cache node instead."
  value       = try(module.redis.cluster_cache_nodes[0].address, null)
}

output "replication_group_primary_endpoint_address" {
  description = "Address of the replication group's primary node, used when create_replication_group is true"
  value       = module.redis.replication_group_primary_endpoint_address
}

output "security_group_id" {
  description = "The ID of the security group attached to the cache"
  value       = module.redis.security_group_id
}
