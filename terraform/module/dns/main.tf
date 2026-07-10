resource "aws_route53_zone" "private" {
  name = var.domain_name

  vpc {
    vpc_id = var.vpc_id
  }

  tags = var.tags
}

resource "aws_route53_record" "records" {
  for_each = var.records

  zone_id = aws_route53_zone.private.zone_id
  name    = "${each.key}.${aws_route53_zone.private.name}"
  type    = "CNAME"
  ttl     = 300
  records = [each.value]
}
