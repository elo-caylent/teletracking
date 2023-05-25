locals {

	tgw_vpn_data = {

		transit_gateway_hub_id = module.tgw.ec2_transit_gateway_id
		
		bgp_vpn_cgw = {
			bgp_asn         = 64802
			ip_address      = "20.7.6.158"
			type            = "ipsec.1"
			name            = "telemsetest-bgp-vpn-cgw-poc"
			dynamic_routing = true
		}
		
		bgp_vpn_connection_specs = {
			name                  = "telemsetest-bgp-vpn-poc"
			tunnel1_inside_cidr   = "169.254.252.0/30"
			tunnel2_inside_cidr   = "169.254.252.4/30"
			tunnel1_preshared_key = "mnBTnk.GlPAjikkxuACuI.9ZqqQIxuWB"
			tunnel2_preshared_key = "mnBTnk.GlPAjikkxuACuI.9ZqqQIxuWB"
			#static_routes_destinations  = optional(list(string), [])
		}
		
		bgp_tgw_vpn_custome_routes = [
			{
			destination_cidr_block = "0.0.0.0/0"
			blackhole              = false
			destination_attachment = module.tgw.ec2_transit_gateway_vpc_attachment_ids[0]
			},
			{
			destination_cidr_block = "10.1.160.0/21"
			blackhole              = true
			},
			{
			destination_cidr_block = "10.1.128.0/20"
			blackhole              = false
			destination_attachment = module.tgw.ec2_transit_gateway_vpc_attachment_ids[0]
			}
		]
		
		bgp_tgw_vpn_propagated_routes = {
			origin_attachments = []
		}
		
		static_vpn_cgw = {
			bgp_asn    = 64577
			ip_address = "20.7.6.194"
			#type           = "ipsec.1"
			name            = "telemsetest-vpn-cgw-poc"
			dynamic_routing = false
		}
		
		static_vpn_connection_specs = {
			name = "telemsetest-vpn-poc"
			#tunnel1_inside_cidr   = "" #IF YOU WANT TO SPECIFY THE CIDR RANGE FOR THE TUNNEL INTERNAL COMMUNICATION, UNCOMMENT THIS AND USE A LINK LOCAL /30 RANGE FROM 169.254.0.0/16
			#tunnel2_inside_cidr   = "" #IF YOU WANT TO SPECIFY THE CIDR RANGE FOR THE TUNNEL INTERNAL COMMUNICATION, UNCOMMENT THIS AND USE A LINK LOCAL /30 RANGE FROM 169.254.0.0/16
			#tunnel1_preshared_key = "" #IF YOU WANT TO SPECIFY THE PRESHARED KEY FOR TE TUNNE AUTHENTICATION, UNCOMENT THIS
			#tunnel2_preshared_key = "" #IF YOU WANT TO SPECIFY THE PRESHARED KEY FOR TE TUNNE AUTHENTICATION, UNCOMENT THIS
			#static_routes_destinations  = optional(list(string), [])
		}
		
		static_tgw_vpn_custome_routes = []
		
		static_tgw_vpn_propagated_routes = {
			origin_attachments = [module.tgw.ec2_transit_gateway_vpc_attachment_ids[0], module.tgw.ec2_transit_gateway_vpc_attachment_ids[1]]
		}
	}

  #LOAD BALANCING DATA
    subnets_for_ingress_nlb = local.ingress_subnets_ids
    subnets_for_prod_appserver_nlb = [local.prv_subnets_ids[0]]
    subnets_for_test_appserver_nlb = [local.prv_subnets_ids[1]]
    subnets_for_hub_alb = local.prv_subnets_ids
    subnets_for_pod_lbs = local.pod_web_subnets_ids
    health_check_for_app_tgs = {
        enabled             = true
        interval            = 30
        port                = 443
        healthy_threshold   = 5
        unhealthy_threshold = 2
        timeout             = 10
        protocol            = "TCP"
    }
    ip_based_1hr_stickiness_nlb = {
        enabled = true
        type = "source_ip"
        cookie_duration = 3600
    }

    prod_rtls_target_group = {
      name = "prod-appserver-rtls-tg"
      backend_protocol = "TLS"
      backend_port     = 443
      target_type      = "ip"
      load_balancing_cross_zone_enabled = true
      targets = {
        my_target = {
            target_id = module.ec2_instances.ec2_instances["CMS-App-Server"].private_ip
            port      = 443
            availability_zone = "all"
        }
      }
      stickiness = local.ip_based_1hr_stickiness_nlb
      health_check = local.health_check_for_app_tgs
    }
    prod_appserver_target_groups = concat([local.prod_rtls_target_group], [for port in var.sip_ports : {name = "prod-appserver-${port}-tg", backend_protocol = "TCP_UDP", backend_port = port, target_type = "ip", load_balancing_cross_zone_enabled = true, targets = {my_target = { target_id = module.ec2_instances.ec2_instances["CMS-App-Server"].private_ip, port = port, availability_zone = "all"}}, stickiness = local.ip_based_1hr_stickiness_nlb, health_check = local.health_check_for_app_tgs}])

    test_rtls_target_group = {
      name = "test-appserver-rtls-tg"
      backend_protocol = "TLS"
      backend_port     = 443
      target_type      = "ip"
      load_balancing_cross_zone_enabled = true
      targets = {
        my_target = {
            target_id = module.ec2_instances.ec2_instances["Test-CMS-App-Server"].private_ip
            port      = 443
            availability_zone = "all"
        }
      }
      stickiness = local.ip_based_1hr_stickiness_nlb
      health_check = local.health_check_for_app_tgs
    }
    test_appserver_target_groups = concat([local.test_rtls_target_group], [for port in var.sip_ports : {name = "test-appserver-${port}-tg", backend_protocol = "TCP_UDP", backend_port = port, target_type = "ip", load_balancing_cross_zone_enabled = true, targets = {my_target = { target_id = module.ec2_instances.ec2_instances["Test-CMS-App-Server"].private_ip, port = port, availability_zone = "all"}}, stickiness = local.ip_based_1hr_stickiness_nlb, health_check = local.health_check_for_app_tgs}])


    prod_app_server_tls_listnerts_nlb = [{
      port               = 443
      protocol           = "TLS"
      certificate_arn    =  var.prod_rtls_listener_certificate_arn
      target_group_index = 0
      stickiness = {
        enabled = true
      }
    }]

    prod_sip_connection_listeners = [for port in var.sip_ports : {port = port, protocol = "TCP", target_group_index = (length(local.prod_app_server_tls_listnerts_nlb) > 0 ? length(local.prod_app_server_tls_listnerts_nlb) : 0) + index(var.sip_ports, port), stickiness = {enabled = true}}]

    test_app_server_tls_listnerts_nlb = [{
      port               = 443
      protocol           = "TLS"
      certificate_arn    =  var.test_rtls_listener_certificate_arn
      target_group_index = 0
      stickiness = {
        enabled = true
      }
    }]

    test_sip_connection_listeners = [for port in var.sip_ports : {port = port, protocol = "TCP", target_group_index = (length(local.test_app_server_tls_listnerts_nlb) > 0 ? length(local.test_app_server_tls_listnerts_nlb) : 0) + index(var.sip_ports, port), stickiness = {enabled = true}}]
}