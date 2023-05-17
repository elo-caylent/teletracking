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

resource "aws_ec2_transit_gateway_route" "default_vpn_att_route" {

  destination_cidr_block = "0.0.0.0/0"

  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpn_att_rt.id
  transit_gateway_attachment_id  = var.vpn_connection_specs.default_route_destination_attachment
}

resource "aws_ec2_transit_gateway_route_table_association" "vpn_att_rt_association" {
  transit_gateway_attachment_id  = aws_vpn_connection.vpn_connection.transit_gateway_attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.vpn_att_rt.id
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
