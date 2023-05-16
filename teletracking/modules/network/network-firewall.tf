module "network_firewall" {
    source  = "mattyait/network-firewall/aws"
    version = "0.1.2"
    firewall_name = "fw-hub"
    vpc_id        = module.vpc.vpc_id
    prefix        = "Hub"

    #Passing Individual Subnet ID to have required endpoint
    subnet_mapping = local.fw_subnets_ids

    fw1-stateful-rg = [
        {
        capacity    = 100
        name        = "stateful"
        description = "Stateful rule example1 with 5 tuple option"
        rule_config = [{
            description           = "Pass All Rule"
            protocol              = "HTTP"
            source_ipaddress      = "any"
            source_port           = "any"
            destination_ipaddress = "10.1.129.0/24"
            destination_port      = [443,80]
            direction             = "Forward"
            sid                   = 1
            actions = {
            type = "pass"
            }
        }]
        },
        {
        capacity    = 100
        name        = "stateful"
        description = "Stateful rule example1 with 5 tuple option"
        rule_config = [{
            description           = "Pass All Rule"
            protocol              = "HTTP"
            source_ipaddress      = "10.1.160.0/21"
            source_port           = "any"
            destination_ipaddress = "any"
            destination_port      = [443,80]
            direction             = "Forward"
            sid                   = 1
            actions = {
            type = "pass"
            }
        }]
        },
        {
        capacity    = 100
        name        = "stateful"
        description = "Stateful rule example1 with 5 tuple option"
        rule_config = [{
            description           = "Pass All Rule"
            protocol              = "HTTP"
            source_ipaddress      = "10.1.160.128/26"
            source_port           = "any"
            destination_ipaddress = "any"
            destination_port      = 5671
            direction             = "Forward"
            sid                   = 1
            actions = {
            type = "pass"
            }
        }]
        },
        {
        capacity    = 100
        name        = "stateful"
        description = "Stateful rule example1 with 5 tuple option"
        rule_config = [{
            description           = "Pass All Rule"
            protocol              = "TCP"
            source_ipaddress      = "any"
            source_port           = "any"
            destination_ipaddress = "10.1.129.0/24"
            destination_port      = [5671, 49100 - 49129]
            direction             = "Forward"
            sid                   = 1
            actions = {
            type = "pass"
            }
        }]
        },
        {
        capacity    = 100
        name        = "stateful"
        description = "Stateful rule example1 with 5 tuple option"
        rule_config = [{
            description           = "Pass All Rule"
            protocol              = "UDP"
            source_ipaddress      = "any"
            source_port           = "any"
            destination_ipaddress = "10.1.129.0/24"
            destination_port      = [5671, 49100 - 49129]
            direction             = "Forward"
            sid                   = 1
            actions = {
            type = "pass"
            }
        }]
        },
        {
        capacity    = 100
        name        = "stateful"
        description = "Stateful rule example1 with 5 tuple option"
        rule_config = [{
            description           = "Pass All Rule"
            protocol              = "TCP"
            source_ipaddress      = ["10.1.160.0/21", "10.1.128.0/20"]
            source_port           = "any"
            destination_ipaddress = "any"
            destination_port      = [5671, 49100 - 49129]
            direction             = "Forward"
            sid                   = 1
            actions = {
            type = "pass"
            }
        }]
        },
        {
        capacity    = 100
        name        = "stateful"
        description = "Stateful rule example1 with 5 tuple option"
        rule_config = [{
            description           = "Pass All Rule"
            protocol              = "UDP"
            source_ipaddress      = ["10.1.160.0/21", "10.1.128.0/20"]
            source_port           = "any"
            destination_ipaddress = "any"
            destination_port      = [5671, 49100 - 49129]
            direction             = "Forward"
            sid                   = 1
            actions = {
            type = "pass"
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
        rule_config = [{
            priority              = 1
            protocols_number      = [1]
            source_ipaddress      = "any"
            source_from_port      = "any"
            source_to_port        = "any"
            destination_ipaddress = "any"
            destination_from_port = "any"
            destination_to_port   = "any"
            tcp_flag = {
            flags = ["SYN"]
            masks = ["SYN", "ACK"]
            }
            actions = {
            type = "drop"
            }
        }]
        }]

    tags = local.tags
}
