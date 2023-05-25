/*
output "ec2_instance_ids" {
  description = "IDs of the created EC2 instances"
  value       = module.ec2_instances.ec2_instance_ids
}

output "iam_instance_profile_name" {
  description = "Name of the created IAM instance profile"
  value       = module.ec2_instances.iam_instance_profile_name
}
*/

output "private_ip" {
  description = "Private IP addresses of the EC2 instances"
  value       = module.ec2_instances.private_ip
}
