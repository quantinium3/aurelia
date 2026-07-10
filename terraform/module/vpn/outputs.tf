output "client_vpn_endpoint_id" {
  description = "The ID of the Client VPN endpoint"
  value       = aws_ec2_client_vpn_endpoint.this.id
}

output "dns_name" {
  description = "The DNS name to be used by clients when establishing their VPN session"
  value       = aws_ec2_client_vpn_endpoint.this.dns_name
}
