# The Transit Gateway (hub) has already been created in AWS, as a fixture for
# this test case due to not being able to use 'depends_on' on Terraform modules
module "vpn" {
    source = "/terraform/modules/tgw_vpn"

    vpn_connection_specs = [{
    customer_gateway = {
      bgp_asn         = 64802
      ip_address      = "20.7.6.158"
      type            = "ipsec.1"
      name            = "telemsetest-bgp-vpn-cgw-poc"
      dynamic_routing = true
    },
    connection      = {
      name                        = "telemsetest-bgp-vpn-poc"
      tunnel1_inside_cidr         = "169.254.252.0/30"
      tunnel2_inside_cidr         = "169.254.252.4/30"
      tunnel1_preshared_key       = "mnBTnk.GlPAjikkxuACuI.9ZqqQIxuWB"
      tunnel2_preshared_key       = "mnBTnk.GlPAjikkxuACuI.9ZqqQIxuWB"
      #static_routes_destinations  = optional(list(string), [])
    },
    default_route_destination_attachment = module.tgw.ec2_transit_gateway_vpc_attachment.id[0]
    },
    {
    customer_gateway = {
      bgp_asn         = 64577
      ip_address      = "20.7.6.194"
      type            = "ipsec.1"
      name            = "telemsetest-vpn-cgw-poc"
      dynamic_routing = false
    },
    connection      = {
      name                        = "telemsetest-vpn-poc"
      tunnel1_inside_cidr         = "169.254.253.0/30"
      tunnel2_inside_cidr         = "169.254.253.4/30"
      tunnel1_preshared_key       = "mnBTnk.GlPAjikkxuACuI.9ZqqQIxuWB"
      tunnel2_preshared_key       = "mnBTnk.GlPAjikkxuACuI.9ZqqQIxuWB"
      #static_routes_destinations  = optional(list(string), [])
    },
    default_route_destination_attachment = module.tgw.ec2_transit_gateway_vpc_attachment.id[0]
    }]

    transit_gateway_hub_id     = module.tgw.ec2_transit_gateway_id
    #transit_gateway_hub_name   = var.transit_gateway_hub_name

    #tags = local.tags
}
