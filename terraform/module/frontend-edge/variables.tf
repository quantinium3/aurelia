variable "name_prefix" {
  description = "Prefix for named resources, e.g. aurelia-dev or aurelia-prod"
  type        = string
}

variable "domain_name" {
  description = "Public hostname served through CloudFront, e.g. aurelia.himanshusolo.dev"
  type        = string
}

variable "hosted_zone_id" {
  description = "Route53 public hosted zone ID that holds domain_name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID the frontend ALB lives in"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name, used to discover the frontend ALB by its elbv2.k8s.aws/cluster tag"
  type        = string
}

variable "price_class" {
  description = "CloudFront price class"
  type        = string
  default     = "PriceClass_100"
}

variable "rate_limit" {
  description = "WAF per-IP request rate limit per 5 minutes"
  type        = number
  default     = 2000
}

variable "tags" {
  description = "Tags applied to created resources"
  type        = map(string)
}
