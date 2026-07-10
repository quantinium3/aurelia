variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
}

variable "cluster_endpoint" {
  description = "The endpoint of the EKS cluster's API server"
  type        = string
}

variable "cluster_certificate_authority_data" {
  description = "The base64 encoded certificate authority data for the EKS cluster"
  type        = string
}

variable "tags" {
  description = "The tags related to the addons"
  type        = map(string)
}

variable "secrets_manager_arns" {
  description = "The ARNs of the Secrets Manager secrets that External Secrets Operator is allowed to read"
  type        = list(string)
}
