locals {
  custome_routes_count = length(var.tgw_vpn_custome_routes) != null ? length(var.tgw_vpn_custome_routes) : 0
  propagated_routes_count = length(var.tgw_vpn_propagated_routes.origin_attachments) != null ? length(var.tgw_vpn_propagated_routes.origin_attachments) : 0
}

resource "aws_customer_gateway" "cgw" {
  bgp_asn    = var.vpn_cgw.bgp_asn
  ip_address = var.vpn_cgw.ip_address
  type       = var.vpn_cgw.type
  tags       = merge(var.tags, { Name = var.vpn_cgw.name })
}

resource "aws_vpn_connection" "vpn_connection" {

  customer_gateway_id   = aws_customer_gateway.cgw.id
  type                  = var.vpn_cgw.type
  transit_gateway_id    = var.transit_gateway_hub_id
  static_routes_only    = !var.vpn_cgw.dynamic_routing
  tunnel1_inside_cidr   = var.vpn_connection_specs.tunnel1_inside_cidr != "" ? var.vpn_connection_specs.tunnel1_inside_cidr : null
  tunnel2_inside_cidr   = var.vpn_connection_specs.tunnel2_inside_cidr != "" ? var.vpn_connection_specs.tunnel2_inside_cidr : null
  tunnel1_preshared_key = var.vpn_connection_specs.tunnel1_preshared_key != "" ? var.vpn_connection_specs.tunnel1_preshared_key : null         
  tunnel2_preshared_key = var.vpn_connection_specs.tunnel2_preshared_key != "" ? var.vpn_connection_specs.tunnel2_preshared_key : null 
  tags                  = merge(var.tags, { Name = var.vpn_connection_specs.name })
}

################################################################################
# Route Table / Routes
################################################################################

resource "aws_ec2_transit_gateway_route_table" "vpn_att_rt" {

  transit_gateway_id = var.transit_gateway_hub_id

  tags = merge(
    var.tags,
    { Name = "${var.vpn_connection_specs.name}_tgw_rt" },
   var.tags,
  )
}

resource "aws_ec2_transit_gateway_route" "custome_route" {
  count = local.custome_routes_count

  destination_cidr_block = var.tgw_vpn_custome_routes[count.index].destination_cidr_block
  blackhole              = var.tgw_vpn_custome_routes[count.index].blackhole

  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpn_att_rt.id
  transit_gateway_attachment_id  = var.tgw_vpn_custome_routes[count.index].blackhole == false ? var.tgw_vpn_custome_routes[count.index].destination_attachment : null
}

resource "aws_ec2_transit_gateway_route_table_propagation" "this" {
  count = local.propagated_routes_count

  transit_gateway_attachment_id  = var.tgw_vpn_propagated_routes.origin_attachments[count.index]
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpn_att_rt.id
}

resource "aws_ec2_transit_gateway_route_table_association" "vpn_att_rt_association" {
  transit_gateway_attachment_id  = aws_vpn_connection.vpn_connection.transit_gateway_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpn_att_rt.id
}
