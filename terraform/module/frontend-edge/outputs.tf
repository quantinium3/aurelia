output "cloudfront_domain_name" {
  description = "The CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.this.domain_name
}

output "cloudfront_distribution_id" {
  description = "The CloudFront distribution ID"
  value       = aws_cloudfront_distribution.this.id
}

output "origin_certificate_arn" {
  description = "ACM cert ARN the frontend ALB serves to CloudFront (put on the ingress certificate-arn annotation)"
  value       = aws_acm_certificate.origin.arn
}

output "alb_security_group_id" {
  description = "Security group locking the frontend ALB to CloudFront (put on the ingress security-groups annotation)"
  value       = aws_security_group.alb.id
}

output "waf_web_acl_arn" {
  description = "The WAFv2 WebACL ARN attached to the CloudFront distribution"
  value       = aws_wafv2_web_acl.this.arn
}
