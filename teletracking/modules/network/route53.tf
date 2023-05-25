
locals {
  zone_name = module.zones.zone_name[0]
}

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


module "records" {
  source  = "./terraform/modules/records"

  zone_name = local.zone_name

  records = [
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
      name = "iq-connector-mse-poc.dev.us1.ttiq.io"
      type = "A"
      ttl  = 300
      records = [
        "10.1.160.182",
      ]
    },
    /*{
      name = "teletracking.dev.us1.ttiq.io"
      type = "A"
      alias = {
        name    = "pod-nlb-mse-poc-c267352b69f0bf36.elb.us-east-1.amazonaws.com."
        zone_id = module.zones.zone_ids
      }
    }*/
  ]

  depends_on = [module.zones]
}

