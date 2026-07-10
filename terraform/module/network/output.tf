output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_name" {
  value = module.vpc.name
}

output "private_subnets" {
  value = module.vpc.private_subnets
}

output "database_subnets" {
  value = module.vpc.database_subnets
}

output "elasticache_subnets" {
  value = module.vpc.elasticache_subnets
}

output "elasticache_subnet_group_name" {
  value = module.vpc.elasticache_subnet_group_name
}
