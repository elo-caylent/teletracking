../../variables.tf
################################################################################
#  TGW VPN
################################################################################

/*
variable "role_to_assume" {
  description = "IAM role name to assume (eg. ASSUME-ROLE-HUB)"
  type        = string
  default     = ""
}

variable "tags" {
  description = "Map of custom tags for the provisioned resources"
  type        = map(string)
  default     = {}
}

variable "vpn_cgw" {
  description = "Customer gateway basic information"
  type = object({
    bgp_asn         = number
    ip_address      = string
    type            = optional(string, "ipsec.1")
    name            = string
    dynamic_routing = bool
  })
}

variable "vpn_connection_specs" {
  description = "Customer gateway basic information"
  type = object({
    name                       = string
    tunnel1_inside_cidr        = optional(string, "")
    tunnel2_inside_cidr        = optional(string, "")
    tunnel1_preshared_key      = optional(string, "")
    tunnel2_preshared_key      = optional(string, "")
    static_routes_destinations = optional(list(string), [])
  })
}

variable "tgw_vpn_custome_routes" {
  description = "Customer gateway basic information"
  type = list(object(
    {
      destination_cidr_block = optional(string, null)
      blackhole              = optional(bool, null)
      destination_attachment = optional(string, null)
  }))
}

variable "tgw_vpn_propagated_routes" {
  description = "Customer gateway basic information"
  type = object(
    {
      origin_attachments = optional(list(string), null)
  })
}

variable "transit_gateway_hub_id" {
  description = "Id of the Transit Gateway to attach the VPN to"
  type        = string
}
*/