# The Transit Gateway (hub) has already been created in AWS, as a fixture for
# this test case due to not being able to use 'depends_on' on Terraform modules
module "bgp_vpn" {
  source = "./terraform/modules/tgw_vpn"


  vpn_cgw = {
    bgp_asn         = 64802
    ip_address      = "25.7.6.158"
    type            = "ipsec.1"
    name            = "test-bgp-vpn-cgw-poc"
    dynamic_routing = true
  }

  vpn_connection_specs = {
    name                  = "test-bgp-vpn-poc"
    tunnel1_inside_cidr   = "169.254.252.0/30"
    tunnel2_inside_cidr   = "169.254.252.4/30"
    tunnel1_preshared_key = "mnBTnk.GlPAjikkxuACuI.9ZqqQIxuWB"
    tunnel2_preshared_key = "mnBTnk.GlPAjikkxuACuI.9ZqqQIxuWB"
    #static_routes_destinations  = optional(list(string), [])
  }

      tgw_vpn_custome_routes = [
        {
          destination_cidr_block = "0.0.0.0/0"
          blackhole             = false
          destination_attachment = "tgw-att-xxxxxxxxxxxxxxxxx"
        },
        {
          destination_cidr_block = "10.1.160.0/21"
          blackhole             = true
          destination_attachment = "" #"tgw-att-xxxxxxxxxxxxxxxxx"
        },
        {
          destination_cidr_block = "10.1.128.0/20"
          blanckhole             = false
          destination_attachment = "tgw-att-xxxxxxxxxxxxxxxxx"
        }
      ]

      tgw_vpn_propagated_routes = {
        origin_attachments = []
      }

  transit_gateway_hub_id = "tgw-xxxxxxxxxxxxxxxxx"

  #tags = local.tags
}
