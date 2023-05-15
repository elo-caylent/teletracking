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
  default     = ["ca-central-1a", "ca-central-1d", "ca-central-1b" ]
}


variable "ingress_subnet_cidr_per_az" {
  description = " Mapping of az to ingress subnets"
  type        = map
  default     = {"ca-central-1a" = "10.1.129.0/27", "ca-central-1d" = "10.1.129.32/27", "ca-central-1b" = "10.1.129.64/27" }
}

variable "fw_subnet_cidr_per_az" {
  description = "Mapping of az to firewall subnet "
  type        = map
  default     = {"ca-central-1a" = "10.1.128.0/28", "ca-central-1d" = "10.1.128.16/28", "ca-central-1b" = "10.1.128.32/28" }
}

variable "tgw_subnet_cidr_per_az" {
  description = "Mapping of az to transit gatway subnet "
  type        = map
  default     = {"ca-central-1a" = "10.1.128.48/28", "ca-central-1d" = "10.1.128.64/28", "ca-central-1b" = "10.1.128.80/28" }
}

variable "prv_subnet_cidr_per_az" {
  description = "Mapping of az to transit gatway subnet "
  type        = map
  default     = {"ca-central-1a" = "10.1.128.96/28", "ca-central-1d" = "10.1.128.112/28", "ca-central-1b" = "10.1.128.128/28" }
}


################################################################################
#  Pod Subnets
################################################################################

variable "az_pod" {
  description = "String of availablity zones "
  type        = set(string)
  default     = ["ca-central-1a", "ca-central-1b" ]
}

variable "podtgw_subnet_cidr_per_az" {
  description = "Mapping of az to transit gatway subnet "
  type        = map
  default     = {"ca-central-1a" = "10.1.160.0/28", "ca-central-1b" = "10.1.160.16/28" }
}

variable "web_subnet_cidr_per_az" {
  description = "Mapping of az to web pod subnet "
  type        = map
  default     = {"ca-central-1a" = "10.1.160.128/26", "ca-central-1b" = "10.1.160.192/26" }
}

variable "app_subnet_cidr_per_az" {
  description = "Mapping of az to app pod subnet "
  type        = map
  default     = {"ca-central-1a" = "10.1.160.64/28", "ca-central-1b" = "10.1.160.80/28" }
}

variable "db_subnet_cidr_per_az" {
  description = "Mapping of az to database pod subnet "
  type        = map
  default     = {"ca-central-1a" = "10.1.161.0/24", "ca-central-1b" = "10.1.162.0/24" }
}

