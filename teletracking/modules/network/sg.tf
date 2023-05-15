resource "aws_security_group" "hub_alb_sg" {
  name        = "hub_alb_sg"
  description = "security group for hub application load balancer"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description      = "allowing https traffic from the internet"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  ingress {
    description      = "allowing http traffic from the internet"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    description      = "allowing http traffic from the internet"
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "app_sg_pod" {
  name        = "app_sg_pod"
  description = "web application sg"
  vpc_id      = module.vpc_pod.vpc_id

  ingress {
    description      = ""
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = values(var.web_subnet_cidr_per_az)
  }
  ingress {
    description      = "HTTPS access from the HUB VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr]
  }
  ingress {
    description      = "HTTPS access from the POD VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    security_groups      = ["${aws_security_group.pod_alb_sg.id}"]
  }
  ingress {
    description      = "sip connections fron the internet"
    from_port        = 5060
    to_port          = 5060
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }
  egress {
    description      = ""
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }


}

resource "aws_security_group" "rds_ec2" {
  name        = "rds_ec2"
  description = "Security group attached to mse-poc to allow EC2 instances with specific security groups attached to connect to the database. Modification could lead to connection loss."
  vpc_id      = module.vpc_pod.vpc_id

  ingress {
    description      = "Rule to allow connections from EC2 instances with sg-017c700ba8ece6e90 attached"
    from_port        = 1433
    to_port          = 1433
    protocol         = "tcp"
    security_groups      = ["${aws_security_group.ec2_rds.id}"]
  }

}

resource "aws_security_group" "ec2_rds" {
  name        = "ec2_rds"
  description = "Security group attached to instances to securely connect to mse-poc. Modification could lead to connection loss."
  vpc_id      = module.vpc_pod.vpc_id

  egress {
    description      = "Rule to allow connections to mse-poc from any instances this security group is attached to"
    from_port        = 1433
    to_port          = 1433
    protocol         = "tcp"
    cidr_blocks      = values(var.web_subnet_cidr_per_az)
  }

}

resource "aws_security_group" "db_sg_pod" {
  name        = "db_sg_pod"
  description = "database pod sg mse-poc"
  vpc_id      = module.vpc_pod.vpc_id

  ingress {
    description      = "allowing traffic from private jumpbox"
    from_port        = 1443
    to_port          = 1443
    protocol         = "tcp"
    cidr_blocks      = ["10.1.128.132/32"]
  }
  ingress {
    description      = "allowing traffic from private jumpbox"
    from_port        = 1443
    to_port          = 1443
    protocol         = "tcp"
    security_groups      = ["${aws_security_group.app_sg_pod.id}"]
  }
  ingress {
    description      = "allowing traffic from Jumpbox to RDS instance"
    from_port        = 1443
    to_port          = 1443
    protocol         = "tcp"
    cidr_blocks      = ["10.1.129.90/32"]
  }
  ingress {
    description      = "allowing traffic from private jumpbox"
    from_port        = 1443
    to_port          = 1443
    protocol         = "tcp"
    security_groups      = ["${aws_security_group.web_sg_pod.id}"]
  }
  egress {
    description      = "allowing traffic from web tier to RDS instance"
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "web_sg_pod" {
  name        = "web_sg_pod"
  description = "web pod sg mse-pocc"
  vpc_id      = module.vpc_pod.vpc_id

  ingress {
    description      = "allow https from app tier sg"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    security_groups      = ["${aws_security_group.app_sg_pod.id}"]
  }
  ingress {
    description      = "allow https from web tier sg"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = values(var.web_subnet_cidr_per_az)
  }
  
  ingress {
    description      = "allow https from pod alb sg"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    security_groups      = ["${aws_security_group.pod_alb_sg.id}"]
  }
  egress {
    description      = ""
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "pod_ssmep_sg" {
  name        = "pod_ssmep_sg"
  description = "security group for ssm endpoints in POD VPC for MSE PoC"
  vpc_id      = module.vpc_pod.vpc_id

  ingress {
    description      = "HTTPS access to SSM from POD VPC VMs"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr_pod]
  }
  egress {
    description      = ""
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}

resource "aws_security_group" "pod_alb_sg" {
  name        = "pod_alb_sg"
  description = "security group for pod application load balancer"
  vpc_id      = module.vpc_pod.vpc_id

  ingress {
    description      = "HTTPS access from the POD VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr_pod]
  }
  ingress {
    description      = "HTTPS access from the HUB VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = [var.vpc_cidr]
  }
  egress {
    description      = ""
    from_port        = 0
    to_port          = 0
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

}




