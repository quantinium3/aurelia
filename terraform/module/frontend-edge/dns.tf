resource "aws_route53_record" "origin" {
  zone_id = var.hosted_zone_id
  name    = local.origin_domain_name
  type    = "A"

  alias {
    name                   = data.aws_lb.frontend.dns_name
    zone_id                = data.aws_lb.frontend.zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "public" {
  zone_id = var.hosted_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = false
  }
}
