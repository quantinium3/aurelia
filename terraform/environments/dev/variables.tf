variable "vpc_name" {
  type = string
}

variable "base_cidr_block" {
  type = string
}

variable "availability_zones" {
  type = list(string)
}

variable "single_nat_gateway" {
  type = bool
}

variable "one_nat_gateway_per_az" {
  type = bool
}

variable "tags" {
  type = map(string)
}

variable "cluster_name" {
  type = string
}

variable "kubernetes_version" {
  type = string
}

variable "node_instance_types" {
  type = list(string)
}

variable "node_capacity_type" {
  type = string
}

variable "node_min_size" {
  type = number
}

variable "node_max_size" {
  type = number
}

variable "node_desired_size" {
  type = number
}

variable "db_identifier" {
  type = string
}

variable "db_instance_class" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "multi_az" {
  type = bool
}

variable "deletion_protection" {
  type = bool
}

variable "skip_final_snapshot" {
  type = bool
}

variable "password_rotation_days" {
  type = number
}

variable "cache_cluster_id" {
  type = string
}

variable "create_replication_group" {
  type = bool
}

variable "cache_engine_version" {
  type = string
}

variable "cache_node_type" {
  type = string
}

variable "cache_num_nodes" {
  type = number
}

variable "cache_transit_encryption_enabled" {
  type = bool
}

variable "vpn_server_certificate_arn" {
  type = string
}

variable "vpn_client_certificate_arn" {
  type = string
}

variable "vpn_client_cidr_block" {
  type = string
}
