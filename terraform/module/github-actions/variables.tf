variable "name" {
  description = "Name prefix for the IAM policy and role"
  type        = string
}

variable "github_repo" {
  description = "The GitHub repository allowed to assume this role, in org/repo format"
  type        = string
}

variable "ecr_repository_arns" {
  description = "The ARNs of the ECR repositories that GitHub Actions is allowed to push images to"
  type        = list(string)
}

variable "tags" {
  description = "Tags related to the GitHub Actions IAM role"
  type        = map(string)
}
