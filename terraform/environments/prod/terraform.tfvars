vpc_name        = "aurelia-prod"
base_cidr_block = "10.1.0.0/16"

availability_zones = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]

single_nat_gateway     = false
one_nat_gateway_per_az = true

tags = {
  Environment = "prod"
  Project     = "aurelia"
}

cluster_name       = "aurelia-prod"
kubernetes_version = "1.36"

node_instance_types = ["m7i-flex.large"]
node_capacity_type  = "ON_DEMAND"

node_min_size     = 2
node_max_size     = 6
node_desired_size = 3

db_identifier         = "aurelia-prod"
db_instance_class     = "db.t4g.medium"
db_name               = "productcatalog"
db_username           = "postgres"
db_master_secret_name = "aurelia/prod/rds/password"

multi_az            = true
deletion_protection = true
skip_final_snapshot = false

cache_cluster_id                 = "aurelia-prod"
create_replication_group         = false
cache_engine_version             = "7.1"
cache_node_type                  = "cache.t4g.micro"
cache_num_nodes                  = 1
cache_transit_encryption_enabled = false

vpn_client_certificate_arn = "arn:aws:acm:ap-south-1:253260001114:certificate/66b360bf-00d3-4a17-814e-7de11b289439"
vpn_client_cidr_block      = "10.101.0.0/22"

internal_domain_name = "internal.himanshu.dev"

frontend_domain_name = "aurelia.himanshusolo.dev"

enable_frontend_edge = false
