variable "cluster_id" {
  description = "The identifier for the elasticache cluster/replication group"
  type        = string
}

variable "create_replication_group" {
  description = "Whether to create a replication group (HA, primary+replica) instead of a single-node cache cluster"
  type        = bool
}

variable "engine_version" {
  description = "The version of the Redis engine to use"
  type        = string
}

variable "node_type" {
  description = "The instance class to use for cache nodes"
  type        = string
}

variable "num_cache_nodes" {
  description = "The number of cache nodes for the cluster"
  type        = number
}

variable "transit_encryption_enabled" {
  description = "Whether to enable in-transit encryption (only supported when create_replication_group is true)"
  type        = bool
}

variable "auth_token" {
  description = "The auth token for the replication group, used only when transit_encryption_enabled is true"
  type        = string
  sensitive   = true
  default     = null
}

variable "vpc_id" {
  description = "The ID of the VPC to deploy the cache into"
  type        = string
}

variable "elasticache_subnets" {
  description = "The subnet IDs to use for the cache subnet group"
  type        = list(string)
}

variable "subnet_group_name" {
  description = "The name of the existing elasticache subnet group (created by the network module) to use"
  type        = string
}

variable "node_security_group_id" {
  description = "The security group ID of the EKS cluster nodes, allowed to reach the cache"
  type        = string
}

variable "tags" {
  description = "The tags related to the cache"
  type        = map(string)
}
