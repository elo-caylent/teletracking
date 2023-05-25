# The Transit Gateway (hub) has already been created in AWS, or it is being created during this same deployment
module "bgp_vpn" {
  source = "./terraform/modules/tgw_vpn"

  vpn_cgw = local.tgw_vpn_data.bgp_vpn_cgw

  vpn_connection_specs = local.tgw_vpn_data.bgp_vpn_connection_specs

  tgw_vpn_custome_routes = local.tgw_vpn_data.bgp_tgw_vpn_custome_routes

  tgw_vpn_propagated_routes = local.tgw_vpn_data.bgp_tgw_vpn_propagated_routes

  transit_gateway_hub_id = local.tgw_vpn_data.transit_gateway_hub_id

  #tags = local.tags
}

module "static_vpn" {
  source = "./terraform/modules/tgw_vpn"

  vpn_cgw = local.tgw_vpn_data.static_vpn_cgw

  vpn_connection_specs = local.tgw_vpn_data.static_vpn_connection_specs

  tgw_vpn_custome_routes = local.tgw_vpn_data.static_tgw_vpn_custome_routes

  tgw_vpn_propagated_routes = local.tgw_vpn_data.static_tgw_vpn_propagated_routes

  transit_gateway_hub_id = local.tgw_vpn_data.transit_gateway_hub_id

  #tags = local.tags
}