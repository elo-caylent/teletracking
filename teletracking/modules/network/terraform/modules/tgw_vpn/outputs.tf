output "customer_gateway_id" {
  description = "ID of the Customer Gateway"
  value       = element(concat(aws_customer_gateway.cgw.*.id, []), 0)
}

output "vpn_connection" {
  description = "VPN connection details"
  value = {
    id                            = element(concat(aws_vpn_connection.vpn_connection.*.id, []), 0)
    transit_gateway_attachment_id = element(concat(aws_vpn_connection.vpn_connection.*.transit_gateway_attachment_id, []), 0)
    tunnel1_address               = element(concat(aws_vpn_connection.vpn_connection.*.tunnel1_address, []), 0)
    tunnel1_cgw_inside_address    = element(concat(aws_vpn_connection.vpn_connection.*.tunnel1_cgw_inside_address, []), 0)
    tunnel1_vgw_inside_address    = element(concat(aws_vpn_connection.vpn_connection.*.tunnel1_vgw_inside_address, []), 0)
    tunnel2_address               = element(concat(aws_vpn_connection.vpn_connection.*.tunnel2_address, []), 0)
    tunnel2_cgw_inside_address    = element(concat(aws_vpn_connection.vpn_connection.*.tunnel2_cgw_inside_address, []), 0)
    tunnel2_vgw_inside_address    = element(concat(aws_vpn_connection.vpn_connection.*.tunnel2_vgw_inside_address, []), 0)
  }
}
