variable "repository_names" {
  description = "Names of the ECR repositories to create, one per microservice"
  type        = list(string)
}

variable "tags" {
  description = "The tags related to the ECR repositories"
  type        = map(string)
}
