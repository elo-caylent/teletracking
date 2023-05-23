resource "aws_route53_zone" "dns_zones" {
  for_each = var.zones

  name        = each.key
  comment     = each.value.comment
  tags        = each.value.tags
}