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
variable "allowed_account_id" {
  description = "AWS account ID for which this module can be executed"
  type        = string
}

variable "role_to_assume" {
  description = "IAM role name to assume (eg. ASSUME-ROLE-HUB)"
  type        = string
  default     = ""
}

variable "vpn_conection_name" {
  description = "Generic name to be given to the provisioned resources"
  type        = string
}
variable "tags" {
  description = "Map of custom tags for the provisioned resources"
  type        = map(string)
  default     = {}
}

variable "cgw_bgp_asn" {
  description = "The gateway's Border Gateway Protocol (BGP) Autonomous System Number (ASN)."
  type        = string
}

variable "cgw_ip_address" {
  description = "IP address of the client VPN endpoint"
  type        = string
}

variable "transit_gateway_hub_name" {
  description = "Name of the Transit Gateway to attach the VPN to"
  type        = string
}

variable "static_routes_only" {
  description = "Whether the VPN connection uses static routes exclusively. Static routes must be used for devices that don't support BGP"
  type        = bool
  default     = false
}

variable "static_routes_destinations" {
  description = "List of CIDRs to be routed into the VPN tunnel."
  type        = list(string)
  default     = []
}

# https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_VpnTunnelOptionsSpecification.html
variable "tunnel1_inside_cidr" {
  description = "A size /30 CIDR block from the 169.254.0.0/16 range"
  type        = string
  default     = null
}

variable "tunnel2_inside_cidr" {
  description = "A size /30 CIDR block from the 169.254.0.0/16 range"
  type        = string
  default     = null
}

variable "tunnel1_preshared_key" {
  description = "Will be stored in the state as plaintext. Must be between 8 & 64 chars and can't start with zero(0). Allowed characters are alphanumeric, periods(.) and underscores(_)"
  default     = null
  type        = string
}

variable "tunnel2_preshared_key" {
  description = "Will be stored in the state as plaintext. Must be between 8 & 64 chars and can't start with zero(0). Allowed characters are alphanumeric, periods(.) and underscores(_)"
  default     = null
  type        = string
}
*/