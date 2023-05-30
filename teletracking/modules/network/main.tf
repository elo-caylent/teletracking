
################################################################################
# HUB VPC Module
################################################################################
module "vpc_hub" {
  source = "./terraform/modules/vpc"

  name = "hub-jesus"
  cidr = var.vpc_cidr

  azs                       = var.az
  private_subnets           = local.private_subnets
  public_subnets            = local.public_subnets
  nat_subnets               = local.ingress_subnets_ids
  enable_nat_gateway        = true
  single_nat_gateway        = false
  one_nat_gateway_per_az    = true
  enable_vpn_gateway        = false
  enable_flow_log           = true
  flow_log_destination_type = "s3"
  bucket_name               = "hub-fl-s3-bucket"
  flow_log_destination_arn  = module.vpc_hub.s3_bucket_arn

  tags = local.tags


}

################################################################################
# POD VPC Module
################################################################################

module "vpc_pod" {
  source = "./terraform/modules/vpc"

  name                      = "pod-jesus"
  cidr                      = var.vpc_cidr_pod
  enable_flow_log           = true
  flow_log_destination_type = "s3"
  bucket_name               = "pod-fl-s3-bucket"
  flow_log_destination_arn  = module.vpc_pod.s3_bucket_arn

  azs             = var.az_pod
  private_subnets = local.pod_private_subnets
  tags = local.tags
}



################################################################################
# POD ENDPOINT Module
################################################################################

module "endpoints_pod" {
  source = "./terraform/modules/vpc/modules/vpc-endpoints"

  vpc_id = module.vpc_pod.vpc_id



  endpoints = {
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = flatten([aws_route_table.pod_rt_db.id, aws_route_table.pod_rt_web_app.id])
      tags            = { Name = "s3-vpc-endpoint" }
    },
    ssm = {
      #interface endpoint
      service    = "ssm"
      tags       = { Name = "ssm-interface-ep-vpc-endpoint" }
      subnet_ids = local.network_interface_subnets_ids
    },
    ssm = {
      #interface endpoint
      service    = "ec2messages"
      tags       = { Name = "ssm-interface-ep-ec2messages-vpc-endpoint" }
      subnet_ids = local.network_interface_subnets_ids
    },
    ec2 = {
      #interface endpoint
      service    = "ec2"
      tags       = { Name = "ssm-interface-ep-ec2-vpc-endpoint" }
      subnet_ids = local.network_interface_subnets_ids
    },
    ssmmessages = {
      #interface endpoint
      service    = "ssmmessages"
      tags       = { Name = "ssm-interface-ep-ssmmessages-vpc-endpoint" }
      subnet_ids = local.network_interface_subnets_ids
    },
    kms = {
      #interface endpoint
      service    = "kms"
      tags       = { Name = "kms-interface-ep-vpc-endpoint" }
      subnet_ids = local.network_interface_subnets_ids
    },
    logs = {
      #interface endpoint
      service    = "logs"
      tags       = { Name = "logs-interface-vpc-endpoint" }
      subnet_ids = local.network_interface_subnets_ids
    },
  }
  tags = local.tags
}

################################################################################
# HUB ENDPOINT Module
################################################################################
module "endpoints_hub" {
  source = "./terraform/modules/vpc/modules/vpc-endpoints"

  vpc_id = module.vpc_hub.vpc_id

  endpoints = {
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = flatten([aws_route_table.ingress1.id, aws_route_table.ingress2.id, aws_route_table.ingress3.id, aws_route_table.prisb1_rt_hub.id, aws_route_table.prisb2_rt_hub.id, aws_route_table.prisb3_rt_hub.id, aws_route_table.fwsb_rt_hub.id])
      tags            = { Name = "hub-s3-gw-endpoint" }
    },
  }
  tags = local.tags
}

################################################################################
# TRANSIT GATEWAY Module
################################################################################

module "tgw" {
  source = "./terraform/modules/tgw"

  name        = "tgw-mse-poc"
  description = "My TGW shared with several other AWS accounts"

  enable_auto_accept_shared_attachments  = true
  enable_default_route_table_association = false

  vpc_attachments = {
    tgw_att_to_hub = {
      vpc_id       = module.vpc_hub.vpc_id
      subnet_ids   = local.tgw_subnets_ids
      dns_support  = true
      ipv6_support = false
      name         = "tgw_att_to_hub"

      tgw_routes = [
        {
          destination_cidr_block = "10.1.160.0/21"
          name                   = "tgw-hub-attch-rt"
        }
      ]
    },
    tgw_att_to_pod = {
      vpc_id       = module.vpc_pod.vpc_id
      subnet_ids   = local.podtgw_subnets_ids
      dns_support  = true
      ipv6_support = false
      name         = "tgw_att_to_pod"

      tgw_routes = [
        {
          destination_cidr_block = "0.0.0.0/0"
          name                   = "tgw-pod-attch-rt"
        }
      ]
    }
  }

  ram_allow_external_principals = true

  tags = local.tags
}

################################################################################
# MANAGED AD Module
################################################################################
module "managed-ad" {
  source = "./terraform/modules/managed-ad"

  ds_managed_ad_directory_name = "dev.us1.ttiq.io"
  ds_managed_ad_password       = "MyStrongPassword123!"
  ds_managed_ad_edition        = "Standard"
  ds_managed_ad_vpc_id         = module.vpc_hub.vpc_id
  ds_managed_ad_subnet_ids     = [local.prv_subnets_ids[0], local.prv_subnets_ids[2]]
}
