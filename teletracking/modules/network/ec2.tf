module "ec2_instances" {
  source = "./terraform/modules/ec2"  # Replace with the actual path to the module code

  instances = [
    {
      name              = "IQ-Connector"
      instance_type     = "t2.micro"
      subnet_id         = local.network_interface_subnets_ids[0]
      security_groups   = [aws_security_group.web_sg_pod.id]
      volume_size       = 256
      volume_type       = "gp3"
      iops              = 3000

    },
    {
      name              = "CMS-Web"
      instance_type     = "t2.small"
      subnet_id         = local.network_interface_subnets_ids[0]
      security_groups   = [aws_security_group.web_sg_pod.id]
      volume_size       = 256
      volume_type       = "gp3"
      iops              = 3000

    },
    {
      name              = "CMS-Web-2"
      instance_type     = "t3.micro"
      subnet_id         = local.network_interface_subnets_ids[0]
      security_groups   = [aws_security_group.web_sg_pod.id]
      volume_size       = 256
      volume_type       = "gp3"
      iops              = 3000

    },
    {
      name              = "CMS-Test-Web"
      instance_type     = "t3.small"
      subnet_id         = local.network_interface_subnets_ids[0]
      security_groups   = [aws_security_group.web_sg_pod.id]
      volume_size       = 256
      volume_type       = "gp3"
      iops              = 3000

    },
    {
      name              = "CMS-App-Server"
      instance_type     = "t3.medium"
      subnet_id         = local.network_interface_subnets_ids[0]
      security_groups   = [aws_security_group.web_sg_pod.id]
      volume_size       = 256
      volume_type       = "gp3"
      iops              = 3000

    },
    {
      name              = "CMS-App-Server"
      instance_type     = "t3.medium"
      subnet_id         = local.network_interface_subnets_ids[0]
      security_groups   = [aws_security_group.web_sg_pod.id]
      volume_size       = 256
      volume_type       = "gp3"
      iops              = 3000
    }
  ]
  iam_instance_profile  = "example-iam-instance-profile"
}
