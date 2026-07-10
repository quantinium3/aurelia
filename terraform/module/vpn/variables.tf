variable "name" {
  description = "The name to prefix the Client VPN endpoint with"
  type        = string
}

variable "server_certificate_arn" {
  description = "The ACM ARN of the server certificate"
  type        = string
}

variable "client_certificate_arn" {
  description = "The ACM ARN of the client certificate, used as the root of trust for validating client connections"
  type        = string
}

variable "client_cidr_block" {
  description = "The CIDR block to assign IP addresses to connected clients from. Must not overlap with the VPC CIDR"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to associate the Client VPN endpoint with"
  type        = string
}

variable "vpc_cidr_block" {
  description = "The CIDR block of the VPC, authorized for VPN clients to reach"
  type        = string
}

variable "subnet_ids" {
  description = "The subnet IDs to associate the Client VPN endpoint with"
  type        = list(string)
}

variable "tags" {
  description = "The tags related to the VPN"
  type        = map(string)
}
