################################################################################
# VPC
################################################################################

variable "vpc_cidr" {
  description = "(Optional) The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length` & `ipv4_ipam_pool_id`"
  type        = string
  default     = "10.1.128.0/20"
}

variable "vpc_cidr_pod" {
  description = "(Optional) The IPv4 CIDR block for the VPC. CIDR can be explicitly set or it can be derived from IPAM using `ipv4_netmask_length` & `ipv4_ipam_pool_id`"
  type        = string
  default     = "10.1.160.0/21"
}

################################################################################
# TAG
################################################################################
variable "environment" {
  description = "A map of tags to add to all resources"
  type        = string
  default     = "mse-poc"
}

variable "costcenter" {
  description = "A map of tags to add to all resources"
  type        = string
  default     = "mse-poc"
}

variable "space" {
  description = "A map of tags to add to all resources"
  type        = string
  default     = "mse-poc"
}

variable "serviceline" {
  description = "A map of tags to add to all resources"
  type        = string
  default     = "mse-poc"
}

variable "dataclassification" {
  description = "A map of tags to add to all resources"
  type        = string
  default     = "mse-poc"
}

variable "map_migrated" {
  description = "A map of tags to add to all resources"
  type        = string
  default     = "mig44451"
}



################################################################################
#  Hub Subnets
################################################################################

variable "az" {
  description = "String of availablity zones "
  type        = set(string)
  default     = ["ap-northeast-1a", "ap-northeast-1c", "ap-northeast-1d"]
}


variable "ingress_subnet_cidr_per_az" {
  description = " Mapping of az to ingress subnets"
  type        = map(any)
  default     = { "ap-northeast-1a" = "10.1.129.0/27", "ap-northeast-1c" = "10.1.129.32/27", "ap-northeast-1d" = "10.1.129.64/27" }
}

variable "fw_subnet_cidr_per_az" {
  description = "Mapping of az to firewall subnet "
  type        = map(any)
  default     = { "ap-northeast-1a" = "10.1.128.0/28", "ap-northeast-1c" = "10.1.128.16/28", "ap-northeast-1d" = "10.1.128.32/28" }
}

variable "tgw_subnet_cidr_per_az" {
  description = "Mapping of az to transit gatway subnet "
  type        = map(any)
  default     = { "ap-northeast-1a" = "10.1.128.48/28", "ap-northeast-1c" = "10.1.128.64/28", "ap-northeast-1d" = "10.1.128.80/28" }
}

variable "prv_subnet_cidr_per_az" {
  description = "Mapping of az to transit gatway subnet "
  type        = map(any)
  default     = { "ap-northeast-1a" = "10.1.128.96/28", "ap-northeast-1c" = "10.1.128.112/28", "ap-northeast-1d" = "10.1.128.128/28" }
}


################################################################################
#  Pod Subnets
################################################################################

variable "az_pod" {
  description = "String of availablity zones "
  type        = set(string)
  default     = ["ap-northeast-1a", "ap-northeast-1c"]
}

variable "podtgw_subnet_cidr_per_az" {
  description = "Mapping of az to transit gatway subnet "
  type        = map(any)
  default     = { "ap-northeast-1a" = "10.1.160.0/28", "ap-northeast-1c" = "10.1.160.16/28" }
}

variable "web_subnet_cidr_per_az" {
  description = "Mapping of az to web pod subnet "
  type        = map(any)
  default     = { "ap-northeast-1a" = "10.1.160.128/26", "ap-northeast-1c" = "10.1.160.192/26" }
}

variable "app_subnet_cidr_per_az" {
  description = "Mapping of az to app pod subnet "
  type        = map(any)
  default     = { "ap-northeast-1a" = "10.1.160.64/28", "ap-northeast-1c" = "10.1.160.80/28" }
}

variable "db_subnet_cidr_per_az" {
  description = "Mapping of az to database pod subnet "
  type        = map(any)
  default     = { "ap-northeast-1a" = "10.1.161.0/24", "ap-northeast-1c" = "10.1.162.0/24" }
}

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

#EC2#
variable "ami_id" {
  description = "default ami for cms ec2 resources "
  type        = string
  default     = "ami-0b7dd7b9e977b2b85"
}

variable "instance_type" {
  description = "default instance type for ec2 resources "
  type        = string
  default     = "t3a.xlarge"
}
variable "volume_sizes" {
  description = "default volume size for ec2 resources "
  type        = string
  default     = "256"
}

variable "volume_types" {
  description = "default volume type for ec2 resources "
  type        = string
  default     = "gp3"
}

variable "iops" {
  description = "default iops type for ec2 resources "
  type        = string
  default     = "3000"
}
