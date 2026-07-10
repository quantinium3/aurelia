variable "domain_name" {
  description = "The domain name for the private hosted zone, e.g. internal.himanshu.dev"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to associate the private hosted zone with"
  type        = string
}

variable "records" {
  description = "Map of record label to target hostname, e.g. { \"productcatalog-db\" = module.database.db_instance_address }"
  type        = map(string)
}

variable "tags" {
  description = "The tags related to the DNS zone"
  type        = map(string)
}
