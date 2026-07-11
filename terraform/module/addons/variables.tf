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

variable "vpc_id" {
  description = "The ID of the VPC the cluster is deployed into"
  type        = string
}

variable "region" {
  description = "The AWS region the cluster is deployed into"
  type        = string
}

variable "public_hosted_zone_id" {
  description = "The ID of the public Route53 hosted zone external-dns is allowed to manage records in"
  type        = string
}

variable "public_domain_name" {
  description = "The public domain name external-dns should limit itself to, e.g. himanshusolo.dev"
  type        = string
}

variable "enable_image_updater" {
  description = "Whether to deploy ArgoCD Image Updater (dev auto-deploys; prod is promotion-only so this is false there)"
  type        = bool
  default     = true
}
