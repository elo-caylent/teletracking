# Create the DNS zones
resource "aws_route53_zone" "zones" {
  for_each = var.zones

  name        = each.key
  comment     = each.value.comment
  tags        = each.value.tags
}