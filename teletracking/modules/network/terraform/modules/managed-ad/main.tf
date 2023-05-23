resource "aws_directory_service_directory" "managed_ad" {
  name         = var.ds_managed_ad_directory_name
  password     = var.ds_managed_ad_password
  edition      = var.ds_managed_ad_edition
  type     = "MicrosoftAD"
  vpc_settings {
    vpc_id               = var.ds_managed_ad_vpc_id
    subnet_ids           = var.ds_managed_ad_subnet_ids
  }
}
