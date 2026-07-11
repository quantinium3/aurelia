resource "aws_acm_certificate" "cloudfront_viewer" {
  provider = aws.us_east_1

  domain_name       = "aurelia.himanshusolo.dev"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

resource "aws_acm_certificate_validation" "cloudfront_viewer" {
  provider = aws.us_east_1

  certificate_arn         = aws_acm_certificate.cloudfront_viewer.arn
  validation_record_fqdns = [aws_route53_record.frontend_cert_validation["aurelia.himanshusolo.dev"].fqdn]
}

resource "aws_acm_certificate" "alb_origin" {
  domain_name       = "origin-aurelia.himanshusolo.dev"
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = var.tags
}

resource "aws_route53_record" "alb_origin_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.alb_origin.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  zone_id = data.aws_route53_zone.public.zone_id
  name    = each.value.name
  type    = each.value.type
  ttl     = 300
  records = [each.value.record]
}

resource "aws_acm_certificate_validation" "alb_origin" {
  certificate_arn         = aws_acm_certificate.alb_origin.arn
  validation_record_fqdns = [for r in aws_route53_record.alb_origin_cert_validation : r.fqdn]
}
