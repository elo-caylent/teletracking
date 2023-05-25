/*locals {

  transit_gateway_hub_id = module.tgw.ec2_transit_gateway_id

  bgp_vpn_cgw = {
    bgp_asn         = 64802
    ip_address      = "20.7.6.158"
    type            = "ipsec.1"
    name            = "telemsetest-bgp-vpn-cgw-poc"
    dynamic_routing = true
  }

  bgp_vpn_connection_specs = {
    name                  = "telemsetest-bgp-vpn-poc"
    tunnel1_inside_cidr   = "169.254.252.0/30"
    tunnel2_inside_cidr   = "169.254.252.4/30"
    tunnel1_preshared_key = "mnBTnk.GlPAjikkxuACuI.9ZqqQIxuWB"
    tunnel2_preshared_key = "mnBTnk.GlPAjikkxuACuI.9ZqqQIxuWB"
    #static_routes_destinations  = optional(list(string), [])
  }

  bgp_tgw_vpn_custome_routes = [
    {
      destination_cidr_block = "0.0.0.0/0"
      blackhole              = false
      destination_attachment = module.tgw.ec2_transit_gateway_vpc_attachment_ids[0]
    },
    {
      destination_cidr_block = "10.1.160.0/21"
      blackhole              = true
    },
    {
      destination_cidr_block = "10.1.128.0/20"
      blackhole              = false
      destination_attachment = module.tgw.ec2_transit_gateway_vpc_attachment_ids[0]
    }
  ]

  bgp_tgw_vpn_propagated_routes = {
    origin_attachments = []
  }

  static_vpn_cgw = {
    bgp_asn    = 64577
    ip_address = "20.7.6.194"
    #type           = "ipsec.1"
    name            = "telemsetest-vpn-cgw-poc"
    dynamic_routing = false
  }

  static_vpn_connection_specs = {
    name = "telemsetest-vpn-poc"
    #tunnel1_inside_cidr   = "" #IF YOU WANT TO SPECIFY THE CIDR RANGE FOR THE TUNNEL INTERNAL COMMUNICATION, UNCOMMENT THIS AND USE A LINK LOCAL /30 RANGE FROM 169.254.0.0/16
    #tunnel2_inside_cidr   = "" #IF YOU WANT TO SPECIFY THE CIDR RANGE FOR THE TUNNEL INTERNAL COMMUNICATION, UNCOMMENT THIS AND USE A LINK LOCAL /30 RANGE FROM 169.254.0.0/16
    #tunnel1_preshared_key = "" #IF YOU WANT TO SPECIFY THE PRESHARED KEY FOR TE TUNNE AUTHENTICATION, UNCOMENT THIS
    #tunnel2_preshared_key = "" #IF YOU WANT TO SPECIFY THE PRESHARED KEY FOR TE TUNNE AUTHENTICATION, UNCOMENT THIS
    #static_routes_destinations  = optional(list(string), [])
  }

  static_tgw_vpn_custome_routes = []

  static_tgw_vpn_propagated_routes = {
    origin_attachments = [module.tgw.ec2_transit_gateway_vpc_attachment_ids[0], module.tgw.ec2_transit_gateway_vpc_attachment_ids[1]]
  }

}*/