resource "aws_placement_group" "pod_placement_group" {
  name       = "pod-placement-group"
  strategy   = "spread"
}

module "ec2_instances" {
  source = "./terraform/modules/ec2"  # Replace with the actual path to the module code

  instances = [
    {
      name              = "IQ-Connector"
      instance_type     = var.instance_type
      subnet_id         = local.network_interface_subnets_ids[0]
      security_groups   = [aws_security_group.web_sg_pod.id]
      volume_size       = var.volume_sizes
      volume_type       = var.volume_types
      iops              = var.iops

    },
    {
      name              = "CMS-Web"
      instance_type     = var.instance_type
      subnet_id         = local.network_interface_subnets_ids[0]
      security_groups   = [aws_security_group.web_sg_pod.id]
      volume_size       = var.volume_sizes
      volume_type       = var.volume_types
      iops              = var.iops
      placement_group     = aws_placement_group.pod_placement_group.name


    },
    {
      name              = "CMS-Web-2"
      instance_type     = var.instance_type
      subnet_id         = local.network_interface_subnets_ids[1]
      security_groups   = [aws_security_group.web_sg_pod.id]
      volume_size       = var.volume_sizes
      volume_type       = var.volume_types
      iops              = var.iops
      placement_group     = aws_placement_group.pod_placement_group.name


    },
    {
      name              = "CMS-Test-Web"
      instance_type     = var.instance_type
      subnet_id         = local.network_interface_subnets_ids[1]
      security_groups   = [aws_security_group.web_sg_pod.id]
      volume_size       = var.volume_sizes
      volume_type       = var.volume_types
      iops              = var.iops

    },
    {
      name              = "CMS-App-Server"
      instance_type     = var.instance_type
      subnet_id         = local.app_subnets_ids[0]
      security_groups   = [aws_security_group.app_sg_pod.id]
      volume_size       = var.volume_sizes
      volume_type       = var.volume_types
      iops              = var.iops

    },
    {
      name              = "Test-CMS-App-Server"
      instance_type     = var.instance_type
      subnet_id         = local.app_subnets_ids[1]
      security_groups   = [aws_security_group.app_sg_pod.id]
      volume_size       = var.volume_sizes
      volume_type       = var.volume_types
      iops              = var.iops
    }
  ]
  iam_instance_profile  = "pod-instance-profile"
}
