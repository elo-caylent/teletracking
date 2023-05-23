variable "ds_managed_ad_directory_name" {
  description = "The name of the AWS Managed Microsoft AD directory"
  type        = string
}

variable "ds_managed_ad_password" {
  description = "The password for the AWS Managed Microsoft AD directory"
  type        = string
}

variable "ds_managed_ad_edition" {
  description = "The edition of the AWS Managed Microsoft AD directory"
  type        = string
}

variable "ds_managed_ad_vpc_id" {
  description = "The ID of the VPC where the AWS Managed Microsoft AD directory should be created"
  type        = string
}

variable "ds_managed_ad_subnet_ids" {
  description = "The IDs of the subnets where the AWS Managed Microsoft AD directory should be created"
  type        = list(string)
}
