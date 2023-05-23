output "managed_ad_id" {
  description = "The ID of the created AWS Managed Microsoft AD directory"
  value       = aws_directory_service_directory.managed_ad.id
}

output "managed_ad_dns_ip_addresses" {
  description = "The DNS IP addresses of the AWS Managed Microsoft AD directory"
  value       = aws_directory_service_directory.managed_ad.dns_ip_addresses
}

output "managed_ad_security_group_id" {
  description = "The security group ID of the AWS Managed Microsoft AD directory"
  value       = aws_directory_service_directory.managed_ad.security_group_id
}

output "managed_ad_connect_settings" {
  description = "The connect settings of the AWS Managed Microsoft AD directory"
  value       = aws_directory_service_directory.managed_ad.connect_settings
}
