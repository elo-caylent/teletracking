/*locals {
  zone_name = sort(keys(module.zones.route53_zone_zone_id))[0]
  zone_id = module.zones.route53_zone_zone_id["terraform-aws-modules-example.com"]
}*/

module "zones" {
  source  = "./terraform/modules/zones_dns"

  zones = {
    "dev.us1.ttiq.io" = {
      comment = "dev.us1.ttiq.io private hosted zone"
      tags = {
        env = "mse_poc"
      }
    }
  }

}


/*module "records" {
  source  = "./terraform/modules/records"

  zone_name = local.zone_name

  records = [
    {
      name = "bus-sandbox-firewall-firmware80.dev.us1.ttiq.io"
      type = "A"
      alias = {
        name    = "rufus-edge-nlb-a92c348dfbde8e77.elb.us-east-1.amazonaws.com."
        zone_id = module.zones.route53_zone_zone_id
      }
    },
    {
      name = "cloudbasix.dev.us1.ttiq.io"
      type = "A"
      ttl  = 300
      records = [
        "10.1.16.125",
      ]
    },
    {
      name = "cms-prod-app-mse-poc.dev.us1.ttiq.io"
      type = "A"
      ttl  = 300
      records = [
        "10.1.160.73",
      ]
    },
    {
      name = "cms-prod1-web-mse-poc.dev.us1.ttiq.io"
      type = "A"
      ttl  = 300
      records = [
        "10.1.160.160",
      ]
    },
    {
      name = "cms-prod2-web-mse-poc.dev.us1.ttiq.io"
      type = "A"
      ttl  = 300
      records = [
        "110.1.160.235",
      ]
    },
    {
      name = "cms-test-app-mse-poc.dev.us1.ttiq.io"
      type = "A"
      ttl  = 300
      records = [
        "10.1.160.87",
      ]
    },
    {
      name = "cms-test-web-mse-poc.dev.us1.ttiq.io"
      type = "A"
      ttl  = 300
      records = [
        "10.1.160.246",
      ]
    },
    {
      name = "ecs-module-test.dev.us1.ttiq.io"
      type = "A"
      alias = {
        name    = "ecsmod20220919180211415000000001-65d4ca3d702e7310.elb.us-east-1.amazonaws.com."
        zone_id = module.zones.route53_zone_zone_id
      }
    },
    {
      name = "firewall-firmware80.dev.us1.ttiq.io"
      type = "A"
      alias = {
        name    = "rufus-edge-nlb-a92c348dfbde8e77.elb.us-east-1.amazonaws.com."
        zone_id = module.zones.route53_zone_zone_id
      }
    },
    {
      name = "ingress.dev.us1.ttiq.io"
      type = "A"
      ttl  = 60
      records = [
        "10.0.3.10",
      ]
    },
    {
      name = "iq-connector-mse-poc.dev.us1.ttiq.io"
      type = "A"
      ttl  = 300
      records = [
        "10.1.160.182",
      ]
    },
    {
      name = "monitoring-sandbox-firewall-firmware80.dev.us1.ttiq.io"
      type = "A"
      alias = {
        name    = "rufus-edge-nlb-a92c348dfbde8e77.elb.us-east-1.amazonaws.com."
        zone_id = module.zones.route53_zone_zone_id
      }
    },
    {
      name = "search.dev.us1.ttiq.io"
      type = "CNAME"
      ttl  = 60
      records = ["www.google.com2"]
    },
    {
      name = "sensor_red.dev.us1.ttiq.io"
      type = "CNAME"
      ttl  = 300
      records = ["ip-10-0-0-14.ec2.internal"]
    },
    {
      name = "teletracking.dev.us1.ttiq.io"
      type = "A"
      alias = {
        name    = "pod-nlb-mse-poc-c267352b69f0bf36.elb.us-east-1.amazonaws.com."
        zone_id = module.zones.route53_zone_zone_id
      }
    },
    {
      name = "viewservice.dev.us1.ttiq.io"
      type = "A"
      alias = {
        name    = "ecsmod-viewservice-nlb-3db088322d6e707b.elb.us-east-1.amazonaws.com."
        zone_id = module.zones.route53_zone_zone_id
      }
    }
  ]

  depends_on = [module.zones]
}*/

