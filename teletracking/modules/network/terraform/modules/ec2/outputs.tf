output "ec2_instance_ids" {
  description = "IDs of the created EC2 instances"
  value       = [for instance in aws_instance.ec2_instances : instance.id]
}

output "ec2_instances" {
  description = "EC2 instances objects"
  value       = aws_instance.ec2_instances
}


output "private_ip" {
  value = { for inst_name, inst in aws_instance.ec2_instances : inst_name => inst.private_ip }
}


output "iam_instance_profile_name" {
  description = "Name of the created IAM instance profile"
  value       = aws_iam_instance_profile.ec2_instance_profile.name
}