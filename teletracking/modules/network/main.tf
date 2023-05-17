locals {
  tags = {
    Name               = "${var.environment}-vpc"
    environment        = "${var.environment}"
    costcenter         = "${var.costcenter}"
    space              = "${var.space}"
    serviceline        = "${var.serviceline}"
    dataclassification = "${var.dataclassification}"
    map-migrated       = "${var.map_migrated}"
  }
  private_subnets      = concat(values(var.prv_subnet_cidr_per_az), values(var.tgw_subnet_cidr_per_az), values(var.ingress_subnet_cidr_per_az))
  pod_private_subnets  = concat(values(var.podtgw_subnet_cidr_per_az), values(var.web_subnet_cidr_per_az), values(var.app_subnet_cidr_per_az), values(var.db_subnet_cidr_per_az))
  public_subnets       = values(var.fw_subnet_cidr_per_az)
  ingress_subnets_cidr = values(var.ingress_subnet_cidr_per_az)
  podtgw_subnet_cidr   = values(var.podtgw_subnet_cidr_per_az)
  websubnet_ids        = values(var.web_subnet_cidr_per_az)


}

module "vpc" {
  source = "./terraform/modules/vpc"

  name = "hub"
  cidr = var.vpc_cidr

  azs                    = var.az
  private_subnets        = local.private_subnets
  public_subnets         = local.public_subnets
  nat_subnets            = local.ingress_subnets_cidr
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true
  enable_vpn_gateway     = true

  #tags = local.tags


}


module "vpc_pod" {
  source = "./terraform/modules/vpc_pod"

  name = "pod"
  cidr = var.vpc_cidr_pod

  azs             = var.az_pod
  private_subnets = local.pod_private_subnets
  #tags = local.tags
}

locals {
  network_interface_subnets_ids = [for subnet in module.vpc_pod.private_subnets : subnet.id if contains(values(var.web_subnet_cidr_per_az), subnet.cidr_block) == true]
  tgw_subnets_ids               = [for subnet in module.vpc.private_subnets : subnet.id if contains(values(var.tgw_subnet_cidr_per_az), subnet.cidr_block) == true]
  podtgw_subnets_ids            = [for subnet in module.vpc_pod.private_subnets : subnet.id if contains(values(var.podtgw_subnet_cidr_per_az), subnet.cidr_block) == true]
  ingress_subnets_ids           = [for subnet in module.vpc.private_subnets : subnet.id if contains(values(var.ingress_subnet_cidr_per_az), subnet.cidr_block) == true]
  fw_subnets_ids                = [for subnet in module.vpc.public_subnets : subnet.id if contains(values(var.fw_subnet_cidr_per_az), subnet.cidr_block) == true]
  prv_subnets_ids               = [for subnet in module.vpc.private_subnets : subnet.id if contains(values(var.prv_subnet_cidr_per_az), subnet.cidr_block) == true]
  app_subnets_ids               = [for subnet in module.vpc_pod.private_subnets : subnet.id if contains(values(var.app_subnet_cidr_per_az), subnet.cidr_block) == true]
  db_subnets_ids                = [for subnet in module.vpc_pod.private_subnets : subnet.id if contains(values(var.db_subnet_cidr_per_az), subnet.cidr_block) == true]
}


module "endpoints" {
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
  #tags = local.tags
}
module "endpoints_hub" {
  source = "./terraform/modules/vpc/modules/vpc-endpoints"

  vpc_id = module.vpc.vpc_id

  endpoints = {
    s3 = {
      service         = "s3"
      service_type    = "Gateway"
      route_table_ids = flatten([aws_route_table.ingress1.id, aws_route_table.ingress2.id, aws_route_table.ingress3.id, aws_route_table.prisb1_rt_hub.id, aws_route_table.prisb2_rt_hub.id, aws_route_table.prisb3_rt_hub.id, aws_route_table.fwsb_rt_hub.id])
      tags            = { Name = "hub-s3-gw-endpoint" }
    },
  }
  #tags = local.tags
}


module "tgw" {
  source = "./terraform/modules/tgw"
  #version = "~> 2.0"

  name        = "tgw-mse-poc"
  description = "My TGW shared with several other AWS accounts"

  enable_auto_accept_shared_attachments = true

  vpc_attachments = {
    tgw_att_to_hub = {
      vpc_id       = module.vpc.vpc_id
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

  #tags = local.tags
}
