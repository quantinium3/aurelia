vpc_name        = "aurelia-dev"
base_cidr_block = "10.0.0.0/16"

availability_zones = ["ap-south-1a", "ap-south-1b"]

single_nat_gateway     = true
one_nat_gateway_per_az = false

tags = {
  Environment = "dev"
  Project     = "aurelia"
}

cluster_name       = "aurelia-dev"
kubernetes_version = "1.36"

node_instance_types = ["m7i-flex.large"]
node_capacity_type  = "SPOT"

node_min_size     = 1
node_max_size     = 3
node_desired_size = 3

db_identifier     = "aurelia-dev"
db_instance_class = "db.t4g.micro"
db_name           = "productcatalog"
db_username       = "postgres"

multi_az            = false
deletion_protection = false
skip_final_snapshot = true

cache_cluster_id                 = "aurelia-dev"
create_replication_group         = false
cache_engine_version             = "7.1"
cache_node_type                  = "cache.t4g.micro"
cache_num_nodes                  = 1
cache_transit_encryption_enabled = false

vpn_client_certificate_arn = "arn:aws:acm:ap-south-1:253260001114:certificate/66b360bf-00d3-4a17-814e-7de11b289439"
vpn_client_cidr_block      = "10.100.0.0/22"

internal_domain_name = "internal.himanshu.dev"

frontend_domain_name = "dev.aurelia.himanshusolo.dev"
