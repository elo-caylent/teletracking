output "zone_ids" {
  value = values(aws_route53_zone.zones)[*].id
}

output "zone_name" {
  description = "The name of the created Route 53 zones."
  value       = values(aws_route53_zone.zones)[*].name
}

