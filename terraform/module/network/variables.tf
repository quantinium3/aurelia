variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}

variable "base_cidr_block" {
  description = "The base CIDR block for subnet"
  type        = string
}

variable "name" {
  description = "The name for the network"
  type        = string
}

variable "tags" {
  description = "The tags related to the network"
  type        = map(string)
}

variable "single_nat_gateway" {
  description = "Whether to provision a single shared NAT gateway for all private subnets instead of one per availability zone"
  type        = bool
}

variable "one_nat_gateway_per_az" {
  description = "Whether to provision one NAT gateway per availability zone for high availability"
  type        = bool
}
