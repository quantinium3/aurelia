module "network" {
  source = "../../module/network"

  name                   = var.vpc_name
  base_cidr_block        = var.base_cidr_block
  availability_zones     = var.availability_zones
  single_nat_gateway     = var.single_nat_gateway
  one_nat_gateway_per_az = var.one_nat_gateway_per_az
  tags                   = var.tags
}

module "cluster" {
  source = "../../module/cluster"

  name               = var.cluster_name
  kubernetes_version = var.kubernetes_version

  vpc_id          = module.network.vpc_id
  private_subnets = module.network.private_subnets

  node_instance_types = var.node_instance_types
  node_capacity_type  = var.node_capacity_type
  node_min_size       = var.node_min_size
  node_max_size       = var.node_max_size
  node_desired_size   = var.node_desired_size

  additional_endpoint_access_cidrs = [var.base_cidr_block]

  tags = var.tags
}

module "database" {
  source = "../../module/database"

  name           = var.db_identifier
  instance_class = var.db_instance_class
  db_name        = var.db_name
  db_username    = var.db_username

  vpc_id           = module.network.vpc_id
  database_subnets = module.network.database_subnets

  node_security_group_id = module.cluster.node_security_group_id

  multi_az            = var.multi_az
  deletion_protection = var.deletion_protection
  skip_final_snapshot = var.skip_final_snapshot

  tags = var.tags
}

module "elasticache" {
  source = "../../module/elasticache"

  cluster_id                 = var.cache_cluster_id
  create_replication_group   = var.create_replication_group
  engine_version             = var.cache_engine_version
  node_type                  = var.cache_node_type
  num_cache_nodes            = var.cache_num_nodes
  transit_encryption_enabled = var.cache_transit_encryption_enabled

  vpc_id              = module.network.vpc_id
  elasticache_subnets = module.network.elasticache_subnets
  subnet_group_name   = module.network.elasticache_subnet_group_name

  node_security_group_id = module.cluster.node_security_group_id

  tags = var.tags
}

module "dns" {
  source = "../../module/dns"

  domain_name = var.internal_domain_name
  vpc_id      = module.network.vpc_id

  records = {
    "productcatalog-db" = module.database.db_instance_address
    "cache"             = module.elasticache.cluster_address
  }

  tags = var.tags
}

module "addons" {
  source = "../../module/addons"

  cluster_name                       = module.cluster.cluster_name
  cluster_endpoint                   = module.cluster.cluster_endpoint
  cluster_certificate_authority_data = module.cluster.cluster_certificate_authority_data

  secrets_manager_arns = [
    module.database.db_instance_master_user_secret_arn,
    data.aws_secretsmanager_secret.image_updater_git_key.arn,
  ]

  vpc_id = module.network.vpc_id
  region = "ap-south-1"

  public_hosted_zone_id = data.aws_route53_zone.public.zone_id
  public_domain_name    = "himanshusolo.dev"

  tags = var.tags
}

module "vpn" {
  source = "../../module/vpn"

  name                   = var.vpc_name
  server_certificate_arn = data.aws_acm_certificate.vpn_server.arn
  client_certificate_arn = var.vpn_client_certificate_arn
  client_cidr_block      = var.vpn_client_cidr_block

  vpc_id         = module.network.vpc_id
  vpc_cidr_block = var.base_cidr_block
  subnet_ids     = module.network.private_subnets

  tags = var.tags
}

module "frontend_edge" {
  source = "../../module/frontend-edge"

  providers = {
    aws           = aws
    aws.us_east_1 = aws.us_east_1
  }

  name_prefix    = var.cluster_name
  domain_name    = var.frontend_domain_name
  hosted_zone_id = data.aws_route53_zone.public.zone_id
  vpc_id         = module.network.vpc_id
  cluster_name   = module.cluster.cluster_name

  tags = var.tags
}

module "monitoring" {
  source = "../../module/monitoring"

  name_prefix        = var.cluster_name
  notification_email = var.alarm_notification_email
  db_identifier      = var.db_identifier
  db_instance_id     = module.database.db_instance_id
  cluster_name       = module.cluster.cluster_name

  tags = var.tags
}
