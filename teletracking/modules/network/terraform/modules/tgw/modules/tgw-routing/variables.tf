variable "tags" {
  description = "Map of custom tags for the provisioned resources"
  type        = map(string)
  default     = {}
}

variable "rt_name" {
  description = "Name for the tgw routing table resource"
  type = string
  default = ""
}

variable "attachment_id" {
    description = "ID of the attachment to apply the routing table to" 
    type = string
}

variable "tgw_custome_routes" {
 description = "Customer gateway basic information"
 type = list(object(
        {
            destination_cidr_block = optional(string, null)
            blackhole             = optional(bool, null)
            destination_attachment = optional(string, null)
        }))
}

variable "tgw_propagated_routes" {
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