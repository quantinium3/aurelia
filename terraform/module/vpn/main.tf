module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 5.0"

  name        = "${var.name}-client-vpn"
  description = "Allow the Client VPN endpoint to reach resources in the VPC"
  vpc_id      = var.vpc_id

  egress_with_cidr_blocks = [
    {
      rule        = "all-all"
      cidr_blocks = var.vpc_cidr_block
    }
  ]

  tags = var.tags
}

resource "aws_ec2_client_vpn_endpoint" "this" {
  description            = "${var.name}-client-vpn"
  server_certificate_arn = var.server_certificate_arn
  client_cidr_block      = var.client_cidr_block
  vpc_id                 = var.vpc_id
  split_tunnel           = true
  security_group_ids     = [module.security_group.security_group_id]

  authentication_options {
    type                       = "certificate-authentication"
    root_certificate_chain_arn = var.client_certificate_arn
  }

  connection_log_options {
    enabled = false
  }

  tags = var.tags
}

resource "aws_ec2_client_vpn_network_association" "this" {
  for_each = { for idx, subnet_id in var.subnet_ids : tostring(idx) => subnet_id }

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  subnet_id              = each.value
}

resource "aws_ec2_client_vpn_authorization_rule" "this" {
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.this.id
  target_network_cidr    = var.vpc_cidr_block
  authorize_all_groups   = true
}
