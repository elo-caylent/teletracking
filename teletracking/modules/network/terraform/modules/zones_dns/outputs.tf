output "zone_ids" {
  description = "The IDs of the created Route 53 zones."

  value = values(aws_route53_zone.dns_zones)[*].zone_id
}

output "zone_names" {
  description = "The names of the created Route 53 zones."

  value = values(aws_route53_zone.dns_zones)[*].name
}
