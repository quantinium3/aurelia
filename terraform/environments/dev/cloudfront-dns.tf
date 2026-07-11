resource "aws_route53_record" "alb_origin" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = "origin-aurelia.himanshusolo.dev"
  type    = "A"

  alias {
    name                   = data.aws_lb.frontend.dns_name
    zone_id                = data.aws_lb.frontend.zone_id
    evaluate_target_health = true
  }
}

import {
  to = aws_route53_record.frontend_public
  id = "Z0580585DYLPFIDRUXP9_aurelia.himanshusolo.dev_A"
}

resource "aws_route53_record" "frontend_public" {
  zone_id = data.aws_route53_zone.public.zone_id
  name    = "aurelia.himanshusolo.dev"
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.frontend.domain_name
    zone_id                = aws_cloudfront_distribution.frontend.hosted_zone_id
    evaluate_target_health = false
  }
}
