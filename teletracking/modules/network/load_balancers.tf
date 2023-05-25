module "web_ingress_nlb" {
  source = "./terraform/modules/alb"

  name = "web-ingress-nlb"

  load_balancer_type = "network"

  vpc_id = module.vpc_hub.vpc_id
  #subnets = local.subnets_for_Ingress_nlb
  use_new_eips = true

  subnet_mapping = [for sub in local.subnets_for_ingress_nlb : { subnet_id = sub, sub_index = index(local.subnets_for_ingress_nlb, sub) }]

  /*
  access_logs = {
    bucket = ""
  }*/

  target_groups = [
    {
      name                              = "hub-alb-http-target"
      backend_protocol                  = "TCP"
      backend_port                      = 80
      target_type                       = "alb"
      load_balancing_cross_zone_enabled = true
      targets = {
        alb_target = {
          target_id = module.hub_alb.lb_arn
          port      = 80
        }
      }
      stickiness = local.ip_based_1hr_stickiness_nlb
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = 80
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 6
        protocol            = "HTTP"
        matcher             = "200-399"
      }
    },
    {
      name = "hub-alb-https-target"
      backend_protocol = "TCP"
      backend_port     = 443
      target_type      = "alb"
      load_balancing_cross_zone_enabled = true
      targets = {
        my_target = {
            target_id = module.hub_alb.lb_arn
            port      = 443
        }
      }
      stickiness = local.ip_based_1hr_stickiness_nlb
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = 443
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 10
        protocol            = "HTTPS"
        matcher             = "200-399"
      }
    }
  ]

  http_tcp_listeners = [
    {
      port               = 80
      protocol           = "TCP"
      target_group_index = 0
      stickiness = {
        enabled = true
      }
    },
    {
      port               = 443
      protocol           = "TCP"
      target_group_index = 1
      stickiness = {
        enabled = true
      }
    }
  ]

  tags = local.tags
}

module "hub_alb" {
  source = "./terraform/modules/alb"

  name = "hub-alb-mse-poc"

  load_balancer_type = "application"

  create_security_group      = true
  security_group_name        = "hub-alb-sg"
  security_group_description = "Security group for the application load balancer in the HUB"
  security_group_rules = {
    allow_all_http_ingress = {
      type        = "ingress"
      description = "allowing traffic to http"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    },
    allow_all_https_ingress = {
      type        = "ingress"
      description = "allowing traffic to https"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  security_group_tags = local.tags

  vpc_id  = module.vpc_hub.vpc_id
  subnets = local.subnets_for_hub_alb

  /*access_logs = {
    bucket = "my-alb-logs"
  }*/

  target_groups = [
    {
      name             = "pod-nlb-ip-target"
      backend_protocol = "HTTPS"
      backend_port     = 443
      target_type      = "ip"
      targets = {
        my_target = {
          target_id         = tolist(module.pod_ingress_nlb.subnet_mapping[0])[0].private_ipv4_address
          port              = 443
          availability_zone = "all"
        }
        my_other_target = {
          target_id         = tolist(module.pod_ingress_nlb.subnet_mapping[0])[1].private_ipv4_address
          port              = 443
          availability_zone = "all"
        }
      }
      stickiness = {
        enabled         = true
        type            = "lb_cookie"
        cookie_duration = 3600
      }
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = 443
        healthy_threshold   = 5
        unhealthy_threshold = 2
        timeout             = 10
        protocol            = "HTTPS"
        matcher             = "200-399"
      }
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = var.hub_alb_listener_certificate_arn
      target_group_index = 0
    }
  ]

  https_listener_rules = [
    {
      https_listener_index = 0
      priority             = 1

      actions = [{
        type        = "redirect"
        path        = "/XT_ts_18_1"
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }]

      conditions = [{
        path_patterns = ["/"]
      }]
    },
    {
      https_listener_index = 0
      priority             = 2

      actions = [{
        type               = "forward"
        target_group_index = 0
      }]

      conditions = [{
        path_patterns = ["/XT_ts_18_1"]
      }]
    }
  ]

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
      stickiness = {
        enabled = true
      }
    }
  ]

  tags = local.tags
}

module "pod_ingress_nlb" {
  source = "./terraform/modules/alb"

  name = "pod-ingress-nlb"

  load_balancer_type = "network"
  internal = true

  vpc_id = module.vpc_pod.vpc_id
  use_new_eips = var.use_new_eips

  subnet_mapping = [for subnet in module.vpc_pod.private_subnets : {subnet_id = subnet.id, private_ipv4_address = "${split(".", split("/", subnet.cidr_block)[0])[0]}.${split(".", split("/", subnet.cidr_block)[0])[1]}.${split(".", split("/", subnet.cidr_block)[0])[2]}.${tonumber(split(".", split("/", subnet.cidr_block)[0])[3]) + var.ip_address_position}"} if contains(values(var.web_subnet_cidr_per_az), subnet.cidr_block) == true]


  /*
  access_logs = {
    bucket = ""
  }*/

  target_groups = [
    {
      name = "pod-alb-https-target"
      backend_protocol = "TCP"
      backend_port     = 443
      target_type      = "alb"
      load_balancing_cross_zone_enabled = true
      targets = {
        my_target = {
            target_id = module.hub_alb.lb_arn
            port      = 443
        }
      }
      stickiness = local.ip_based_1hr_stickiness_nlb
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = 443
        healthy_threshold   = 3
        unhealthy_threshold = 3
        timeout             = 10
        protocol            = "HTTPS"
        matcher             = "200-399"
      }
    }
  ]

  http_tcp_listeners = [
    {
      port               = 443
      protocol           = "TCP"
      target_group_index = 0
      stickiness = {
        enabled = true
      }
    }
  ]

  tags = local.tags
}

module "pod_alb" {
  source = "./terraform/modules/alb"

  name = "pod-alb-mse-poc"

  load_balancer_type = "application"
  internal = true

  create_security_group      = true
  security_group_name        = "pod-alb-sg"
  security_group_description = "Security group for the application load balancer in the POD"
  security_group_rules = {
    allow_all_http_ingress = {
      type        = "ingress"
      description = "allowing http traffic from hub alb"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = values(var.prv_subnet_cidr_per_az)
    },
    allow_all_https_ingress = {
      type        = "ingress"
      description = "allowing https traffic from hub alb"
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = values(var.prv_subnet_cidr_per_az)
    }
  }
  security_group_tags = local.tags

  vpc_id  = module.vpc_pod.vpc_id
  subnets = local.subnets_for_pod_lbs

  /*access_logs = {
    bucket = "my-alb-logs"
  }*/

  target_groups = [
    {
      name             = "pod-alb-instance-tg"
      backend_protocol = "HTTPS"
      backend_port     = 443
      target_type      = "instance"
      targets = {
        my_target = {
          target_id         = module.ec2_instances.ec2_instances["CMS-Web"].id
          port              = 443
        }
        my_other_target = {
          target_id         = module.ec2_instances.ec2_instances["CMS-Web-2"].id
          port              = 443
        }
      }
      stickiness = {
        enabled         = true
        type            = "lb_cookie"
        cookie_duration = 3600
      }
      health_check = {
        enabled             = true
        interval            = 30
        path                = "/"
        port                = 443
        healthy_threshold   = 5
        unhealthy_threshold = 2
        timeout             = 10
        protocol            = "HTTPS"
        matcher             = "200-399"
      }
    }
  ]

  https_listeners = [
    {
      port               = 443
      protocol           = "HTTPS"
      certificate_arn    = var.pod_alb_listener_certificate_arn
      target_group_index = 0
    }
  ]

  https_listener_rules = [
    {
      https_listener_index = 0
      priority             = 1

      actions = [{
        type        = "redirect"
        path        = "/XT_ts_18_1"
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }]

      conditions = [{
        path_patterns = ["/"]
      }]
    },
    {
      https_listener_index = 0
      priority             = 2

      actions = [{
        type               = "forward"
        target_group_index = 0
      }]

      conditions = [{
        path_patterns = ["/XT_ts_18_1"]
      }]
    }
  ]

  http_tcp_listeners = [
    {
      port        = 80
      protocol    = "HTTP"
      action_type = "redirect"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
      stickiness = {
        enabled = true
      }
    }
  ]

  tags = local.tags
}

module "prod_appserver_nlb" {
  source = "./terraform/modules/alb"

  name = "prod-appserver-ingress-nlb"

  load_balancer_type = "network"

  vpc_id = module.vpc_hub.vpc_id
  #subnets = local.subnets_for_Ingress_nlb
  use_new_eips = true

  subnet_mapping = [for sub in local.subnets_for_prod_appserver_nlb : { subnet_id = sub, sub_index = index(local.subnets_for_prod_appserver_nlb, sub) }]

  target_groups = local.prod_appserver_target_groups
  
  https_listeners = local.prod_app_server_tls_listnerts_nlb

  http_tcp_listeners = local.prod_sip_connection_listeners

  tags = local.tags
}

module "test_appserver_nlb" {
  source = "./terraform/modules/alb"

  name = "test-appserver-ingress-nlb"

  load_balancer_type = "network"

  vpc_id = module.vpc_hub.vpc_id
  #subnets = local.subnets_for_test_appserver_nlb
  use_new_eips = true

  subnet_mapping = [for sub in local.subnets_for_test_appserver_nlb : { subnet_id = sub, sub_index = index(local.subnets_for_test_appserver_nlb, sub) }]
  
  target_groups = local.test_appserver_target_groups
  
  https_listeners = local.test_app_server_tls_listnerts_nlb

  http_tcp_listeners = local.test_sip_connection_listeners

  tags = local.tags
}
