/*
resource "aws_route_table" "tgwep1_rt_hub" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = module.vpc.natgw_ids[0]
  }
  route {
    cidr_block         = "10.1.160.0/21"
    transit_gateway_id = module.tgw.ec2_transit_gateway_id
  }

}

resource "aws_route_table" "tgwep2_rt_hub" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = module.vpc.natgw_ids[1]
  }
  route {
    cidr_block         = "10.1.160.0/21"
    transit_gateway_id = module.tgw.ec2_transit_gateway_id
  }

}

resource "aws_route_table" "tgwep3_rt_hub" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = module.vpc.natgw_ids[2]
  }
  route {
    cidr_block         = "10.1.160.0/21"
    transit_gateway_id = module.tgw.ec2_transit_gateway_id
  }

}

resource "aws_route_table" "prisb1_rt_hub" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = module.vpc.natgw_ids[0]
  }
  route {
    cidr_block         = "10.1.160.0/21"
    transit_gateway_id = module.tgw.ec2_transit_gateway_id
  }

}

resource "aws_route_table" "prisb2_rt_hub" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = module.vpc.natgw_ids[1]
  }
  route {
    cidr_block         = "10.1.160.0/21"
    transit_gateway_id = module.tgw.ec2_transit_gateway_id
  }

}

resource "aws_route_table" "prisb3_rt_hub" {
  vpc_id = module.vpc.vpc_id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = module.vpc.natgw_ids[2]
  }
  route {
    cidr_block         = "10.1.160.0/21"
    transit_gateway_id = module.tgw.ec2_transit_gateway_id
  }

}

resource "aws_route_table" "pod_rt_db" {
  vpc_id = module.vpc_pod.vpc_id

  route {
    cidr_block         = "10.1.128.0/20"
    transit_gateway_id = module.tgw.ec2_transit_gateway_id
  }

}


resource "aws_route_table" "pod_rt_tgwep" {
  vpc_id = module.vpc_pod.vpc_id

  route {
    cidr_block         = "0.0.0.0/0"
    transit_gateway_id = module.tgw.ec2_transit_gateway_id
  }

}

resource "aws_route_table" "pod_rt_web_app" {
  vpc_id = module.vpc_pod.vpc_id

  route {
    cidr_block         = "0.0.0.0/0"
    transit_gateway_id = module.tgw.ec2_transit_gateway_id
  }

}


resource "aws_route_table" "ingress1" {
  vpc_id = module.vpc.vpc_id
  route {
    cidr_block         = "10.1.160.0/21"
    transit_gateway_id = module.tgw.ec2_transit_gateway_id
  }

}

resource "aws_route_table" "ingress2" {
  vpc_id = module.vpc.vpc_id
  route {
    cidr_block         = "10.1.160.0/21"
    transit_gateway_id = module.tgw.ec2_transit_gateway_id
  }

}

resource "aws_route_table" "ingress3" {
  vpc_id = module.vpc.vpc_id
  route {
    cidr_block         = "10.1.160.0/21"
    transit_gateway_id = module.tgw.ec2_transit_gateway_id
  }

}

resource "aws_route_table" "fwsb_rt_hub" {
  vpc_id = module.vpc.vpc_id
  route {
    cidr_block         = "10.1.160.0/21"
    transit_gateway_id = module.tgw.ec2_transit_gateway_id
  }

}
*/