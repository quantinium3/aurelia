variable "name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "The Kubernetes version to use for the EKS cluster"
  type        = string
}

variable "tags" {
  description = "The tags related to the cluster"
  type        = map(string)
}

variable "vpc_id" {
  description = "The ID of the VPC to deploy the cluster into"
  type        = string
}

variable "private_subnets" {
  description = "The private subnet IDs to deploy the cluster and node groups into"
  type        = list(string)
}

variable "node_instance_types" {
  description = "The EC2 instance types to use for the default managed node group"
  type        = list(string)
}

variable "node_capacity_type" {
  description = "The capacity type for the default managed node group (ON_DEMAND or SPOT)"
  type        = string
}

variable "node_min_size" {
  description = "The minimum number of nodes in the default managed node group"
  type        = number
}

variable "node_max_size" {
  description = "The maximum number of nodes in the default managed node group"
  type        = number
}

variable "node_desired_size" {
  description = "The desired number of nodes in the default managed node group"
  type        = number
}

variable "additional_endpoint_access_cidrs" {
  description = "Additional CIDR blocks allowed to reach the cluster's API server on port 443, e.g. the Client VPN's client_cidr_block"
  type        = list(string)
}
