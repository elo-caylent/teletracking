locals {
    custome_routes_count = length(var.tgw_custome_routes) != null ? length(var.tgw_custome_routes) : 0
    propagated_routes_count = length(var.tgw_propagated_routes.origin_attachments) != null ? length(var.tgw_propagated_routes.origin_attachments) : 0
}
################################################################################
# Route Table / Routes
################################################################################
resource "aws_ec2_transit_gateway_route_table" "att_rt" {

    transit_gateway_id = var.transit_gateway_hub_id

    tags = merge(
        var.tags,
        { Name = var.rt_name != "" ? var.rt_name : "${var.attachment_id}_rt" },
        var.tags,
    )
}

resource "aws_ec2_transit_gateway_route" "custome_route" {
  count = local.custome_routes_count

  destination_cidr_block = var.tgw_custome_routes[count.index].destination_cidr_block
  blackhole              = var.tgw_custome_routes[count.index].blackhole

  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.att_rt.id
  transit_gateway_attachment_id  = var.tgw_custome_routes[count.index].blackhole == false ? var.tgw_custome_routes[count.index].destination_attachment : null
}

resource "aws_ec2_transit_gateway_route_table_propagation" "rt_propagation" {
  count = local.propagated_routes_count

  transit_gateway_attachment_id  = var.attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.att_rt.id
}

resource "aws_ec2_transit_gateway_route_table_association" "att_rt_association" {
  transit_gateway_attachment_id  = var.attachment_id
  transit_gateway_route_table_id = aws_ec2_transit_gateway_route_table.att_rt.id
}
