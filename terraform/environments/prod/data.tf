data "aws_acm_certificate" "vpn_server" {
  domain = "server"
  types  = ["IMPORTED"]
}

data "aws_route53_zone" "public" {
  name         = "himanshusolo.dev"
  private_zone = false
}
