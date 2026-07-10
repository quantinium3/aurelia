output "zone_id" {
  description = "The ID of the private hosted zone"
  value       = aws_route53_zone.private.zone_id
}

output "record_fqdns" {
  description = "Map of record label to its fully qualified domain name"
  value       = { for k, v in aws_route53_record.records : k => v.fqdn }
}
