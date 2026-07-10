module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.6.1"

  name = var.name
  cidr = var.base_cidr_block
  azs  = var.availability_zones
  tags = var.tags

  enable_nat_gateway     = true
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az

  private_subnets     = [for az in var.availability_zones : module.subnets.network_cidr_blocks["private-${az}"]]
  database_subnets    = [for az in var.availability_zones : module.subnets.network_cidr_blocks["database-${az}"]]
  elasticache_subnets = [for az in var.availability_zones : module.subnets.network_cidr_blocks["elasticache-${az}"]]
  intra_subnets       = [for az in var.availability_zones : module.subnets.network_cidr_blocks["intra-${az}"]]
  public_subnets      = [for az in var.availability_zones : module.subnets.network_cidr_blocks["public-${az}"]]

  # Lets the AWS Load Balancer Controller auto-discover subnets for
  # internet-facing vs internal ALBs/NLBs when Ingress omits explicit subnet IDs.
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  manage_default_security_group  = true
  default_security_group_ingress = []
  default_security_group_egress  = []
}

module "subnets" {
  source  = "hashicorp/subnets/cidr"
  version = "1.0.0"

  base_cidr_block = var.base_cidr_block
  networks = flatten([
    for k, v in local.subnets : [
      for az in var.availability_zones : {
        name     = "${k}-${az}"
        new_bits = v
      }
    ]
  ])
}
