# AWS EC2 Instance Terraform module

Terraform module which creates an EC2 instance on AWS.

## Usage

### Single EC2 Instance

```hcl
module "ec2_instance" {
  source  = "terraform/modules"
  instances = [
    {
        name= "single-instance"
        instance_type          = "t2.micro"
        subnet_id              = "subnet-eddcdzz4"
        security_groups = ["sg-12345678"]
        volume_size       = "50"
        volume_type       = "gp3"
        iops              = "3000"
        placement_group     = "name_of_placement_group"
    }
  ]
  iam_instance_profile  = "iam_profile_name"
}
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 4.20 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 4.20 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_policy_document.assume_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |


## Variables description

- **name (string)**: Name of EC2 instance

- **instance_type (string)**: The instance type of the EC2 instance

- **subnet_id (string)**: The subnet id required for the EC2 instance

- **volume_size(number)**: The volume size of the EC2 instance

- **volume_type (string)** : The volume type of the EC2 instance

- **iops (number)** : The number of Iops required for the EC2 instance

- **placement_group  optional(string)** : The name of the instance placement group

- **security_groups list(string)** : Security group id of the instance

- **iam_instance_profile (string)** : Name of the created IAM instance profile




## Outputs

- **ec2_instance_ids list(string)** : IDs of the created EC2 instances

- **ec2_instances (string)** : EC2 instances objects

- **private_ip (string)** : Private IP of instance

- **iam_instance_profile_name (string)** : Name of the created IAM instance profile