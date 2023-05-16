resource "aws_customer_gateway" "cgw" {
  for_each = var.vpn_connection_specs
  bgp_asn    = each.value.customer_gateway[bgp_asn]
  ip_address = each.value.customer_gateway[ip_address]
  type       = each.value.customer_gateway[type]
  tags       = merge(var.tags, { Name = each.value.customer_gateway[name] })
}

resource "aws_vpn_connection" "vpn_connection" {
  depends_on = [aws_customer_gateway.cgw]
  for_each = var.vpn_connection_specs
  customer_gateway_id   = [for cgw in aws_customer_gateway.cgw : cgw.id if cgw.name == each.value.customer_gateway[name]][0]
  type                  = each.value.customer_gateway[type]
  transit_gateway_id    = var.transit_gateway_hub_id
  static_routes_only    = !each.value.customer_gateway[dynamic_routing]
  tunnel1_inside_cidr   = each.value.connection[tunnel1_inside_cidr]
  tunnel2_inside_cidr   = each.value.connection[tunnel2_inside_cidr]
  tunnel1_preshared_key = each.value.connection[tunnel1_preshared_key]
  tunnel2_preshared_key = each.value.connection[tunnel2_preshared_key]
  tags                  = merge(var.tags, { Name = each.value.connection[name] })
}

################################################################################
# Route Table / Routes
################################################################################

resource "aws_ec2_transit_gateway_route_table" "vpn_att_rt" {
  for_each = var.vpn_connection_specs

  transit_gateway_id = var.transit_gateway_hub_id

  tags = merge(
    var.tags,
    { Name = "${each.value.connection[name]}_tgw_rt" },
   var.tags,
  )
}

resource "aws_ec2_transit_gateway_route" "default_vpn_att_route" {
  for_each = var.vpn_connection_specs

  destination_cidr_block = "0.0.0.0/0"

  transit_gateway_route_table_id = [for tgwrt in aws_ec2_transit_gateway_route_table.vpn_att_rt : tgwrt.id if contains(tgwrt.tags_all[Name], each.value.connection[name]) == true][0]
  transit_gateway_attachment_id  = each.value.default_route_destination_attachment
}

resource "aws_ec2_transit_gateway_route_table_association" "vpn_att_rt_association" {
  for_each = var.vpn_connection_specs

  transit_gateway_attachment_id  = [for vpncon in aws_vpn_connection.vpn_connection : vpncon.transit_gateway_attachment_id if vpncon.tags_all[Name] == each.value.connection[name]][0]
  transit_gateway_route_table_id = [for tgwrt in aws_ec2_transit_gateway_route_table.vpn_att_rt : tgwrt.id if contains(tgwrt.tags_all[Name], each.value.connection[name]) == true][0]
}

/*
resource "aws_ec2_transit_gateway_route_table_propagation" "this" {
  transit_gateway_attachment_id  = aws_vpn_connection.this.transit_gateway_attachment_id
  transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.this.id
}

resource "aws_ec2_transit_gateway_route" "this" {
  count                          = var.static_routes_only ? length(var.static_routes_destinations) : 0
  destination_cidr_block         = element(var.static_routes_destinations, count.index)
  transit_gateway_attachment_id  = aws_vpn_connection.this.transit_gateway_attachment_id
  transit_gateway_route_table_id = data.aws_ec2_transit_gateway_route_table.this.id
}
*/
