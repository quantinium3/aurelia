variable "name" {
  description = "Name for the runner instance and related resources"
  type        = string
}

variable "env_label" {
  description = "GitHub Actions runner label identifying the environment, e.g. aurelia-dev"
  type        = string
}

variable "github_repo_url" {
  description = "Full https URL of the GitHub repo the runner registers to"
  type        = string
}

variable "registration_token" {
  description = "Short-lived GitHub Actions runner registration token (used only at first creation)"
  type        = string
  sensitive   = true
  default     = ""
}

variable "runner_version" {
  description = "GitHub Actions runner release version"
  type        = string
  default     = "2.335.1"
}

variable "instance_type" {
  description = "EC2 instance type for the runner"
  type        = string
  default     = "t3.small"
}

variable "vpc_id" {
  description = "VPC the runner lives in (must be the cluster's VPC to reach its private API endpoint)"
  type        = string
}

variable "subnet_id" {
  description = "Private subnet with NAT egress for the runner"
  type        = string
}

variable "tags" {
  description = "Tags applied to created resources"
  type        = map(string)
}
