locals {
  instances_map = { for inst in var.instances : inst.name => inst }
}

resource "aws_instance" "ec2_instances" {
  for_each      = local.instances_map
  ami           = "ami-035f902e3a175fb99"  # Replace with your desired AMI ID
  instance_type = each.value.instance_type
  subnet_id     = each.value.subnet_id
  security_groups = each.value.security_groups

  # Conditional expression to include placement group if provided
  placement_group = each.value.placement_group != null ? each.value.placement_group : null

  # Add any additional configuration as needed

  ebs_block_device {
    device_name           = "/dev/sda1"
    volume_size           = each.value.volume_size
    volume_type           = each.value.volume_type
    iops                  = each.value.iops
    delete_on_termination = true
  }

  tags = {
    Name = each.value.name
  }
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = var.iam_instance_profile
}

resource "aws_iam_role" "ec2_role" {
  name               = "${var.iam_instance_profile}-role"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ec2_policy_attachment" {
  role       = aws_iam_role.ec2_role.name
  policy_arn = aws_iam_policy.ec2_policy.arn
}

resource "aws_iam_policy" "ec2_policy" {
  name        = "${var.iam_instance_profile}-policy"
  description = "Policy for ${var.iam_instance_profile}"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "s3:ListBucket",
        "s3:GetObject"
      ],
      "Resource": [
        "arn:aws:s3:::example-bucket",
        "arn:aws:s3:::example-bucket/*"
      ]
    }
  ]
}
EOF
}

