/*
module "network_firewall" {
  source        = "./terraform/modules/network_firewall"
  firewall_name = "fw-hub"
  vpc_id        = module.vpc.vpc_id
  prefix        = "Hub"

  #Passing Individual Subnet ID to have required endpoint
  subnet_mapping = local.fw_subnets_ids

  fivetuple_stateful_rule_group = [
    {
      capacity    = 100
      name        = "stateful-rule-set"
      description = "5 tuple Stateful rule set for MSE PoC"

      rule_variables = {
        ip_sets = [
          {
            key    = "HOME_NET"
            ip_set = ["10.1.160.0/21", "10.1.128.0/20"]
          }
        ]
        port_sets = [
          {
            key       = "SIP_PORTS"
            port_sets = ["5060", "49100", "49101", "49102", "49103", "49104", "49105", "49106", "49107", "49108", "49109", "49110", "49111", "49112", "49113", "49114", "49115", "49116", "49117", "49118", "49119", "49120", "49121", "49122", "49123", "49124", "49125", "49126", "49127", "49128", "49129"]
          },
          {
            key       = "WEB_PORTS"
            port_sets = ["443", "80"]
          }
        ]
      }

      rule_config = [
        {
          description           = "Pass All Rule"
          protocol              = "TCP"
          source_ipaddress      = "0.0.0.0/0"
          source_port           = "ANY"
          destination_ipaddress = "10.1.129.0/24"
          destination_port      = "$SIP_PORTS"
          direction             = "Forward"
          sid                   = 1
          actions = {
            type = "PASS"
          }
        },
        {
          description           = "Pass All Rule"
          protocol              = "HTTP"
          source_ipaddress      = "$HOME_NET"
          source_port           = "ANY"
          destination_ipaddress = "0.0.0.0/0"
          destination_port      = "$WEB_PORTS"
          direction             = "Forward"
          sid                   = 2
          actions = {
            type = "PASS"
          }
        },
        {
          description           = "Pass All Rule"
          protocol              = "TCP"
          source_ipaddress      = "10.1.160.128/26"
          source_port           = "ANY"
          destination_ipaddress = "0.0.0.0/0"
          destination_port      = "5671"
          direction             = "Forward"
          sid                   = 3
          actions = {
            type = "PASS"
          }
        },
        {
          description           = "Pass All Rule"
          protocol              = "TCP"
          source_ipaddress      = "0.0.0.0/0"
          source_port           = "ANY"
          destination_ipaddress = "10.1.129.0/24"
          destination_port      = "5671"
          direction             = "Forward"
          sid                   = 4
          actions = {
            type = "PASS"
          }
        },
        {
          description           = "Pass All Rule"
          protocol              = "UDP"
          source_ipaddress      = "0.0.0.0/0"
          source_port           = "ANY"
          destination_ipaddress = "10.1.129.0/24"
          destination_port      = "5671"
          direction             = "Forward"
          sid                   = 5
          actions = {
            type = "PASS"
          }
        },
        {
          description           = "Pass All Rule"
          protocol              = "TCP"
          source_ipaddress      = "10.1.160.0/21" #, "10.1.128.0/20"
          source_port           = "ANY"
          destination_ipaddress = "0.0.0.0/0"
          destination_port      = "5671"
          direction             = "Forward"
          sid                   = 6
          actions = {
            type = "PASS"
          }
        },
        {
          description           = "Pass All Rule"
          protocol              = "UDP"
          source_ipaddress      = "10.1.160.0/21" #, "10.1.128.0/20"
          source_port           = "ANY"
          destination_ipaddress = "0.0.0.0/0"
          destination_port      = "5671"
          direction             = "Forward"
          sid                   = 7
          actions = {
            type = "PASS"
          }
      }]
    },
  ]

  # Stateless Rule Group
  stateless_rule_group = [
    {
      capacity    = 100
      name        = "stateless"
      description = "Stateless rule example1"
      rule_config = [
        {
          priority              = 1
          protocols_number      = [1]
          source_ipaddress      = "0.0.0.0/0"
          source_from_port      = "ANY"
          source_to_port        = "ANY"
          destination_ipaddress = "0.0.0.0/0"
          destination_from_port = "ANY"
          destination_to_port   = "ANY"
          tcp_flag = {
            flags = ["SYN"]
            masks = ["SYN", "ACK"]
          }
          actions = {
            type = "DROP"
          }
        },
      ]
  }]

  tags = local.tags
}*/