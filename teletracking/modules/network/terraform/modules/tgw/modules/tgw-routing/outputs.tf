################################################################################
# Route Table / Routes
################################################################################

output "ec2_transit_gateway_route_table_id" {
  description = "EC2 Transit Gateway Route Table identifier"
  value       = try(aws_ec2_transit_gateway_route_table.att_rt.id, "")
}

output "ec2_transit_gateway_route_table_default_association_route_table" {
  description = "Boolean whether this is the default association route table for the EC2 Transit Gateway"
  value       = try(aws_ec2_transit_gateway_route_table.att_rt.default_association_route_table, "")
}

output "ec2_transit_gateway_route_table_default_propagation_route_table" {
  description = "Boolean whether this is the default propagation route table for the EC2 Transit Gateway"
  value       = try(aws_ec2_transit_gateway_route_table.att_rt.default_propagation_route_table, "")
}

output "ec2_transit_gateway_route_ids" {
  description = "List of EC2 Transit Gateway Route Table identifier combined with destination"
  value       = aws_ec2_transit_gateway_route.custome_route[*].id
}

output "ec2_transit_gateway_route_table_association_ids" {
  description = "List of EC2 Transit Gateway Route Table Association identifiers"
  value       = [for k, v in aws_ec2_transit_gateway_route_table_association.att_rt_association : v]
}

output "ec2_transit_gateway_route_table_association" {
  description = "Map of EC2 Transit Gateway Route Table Association attributes"
  value       = aws_ec2_transit_gateway_route_table_association.att_rt_association
}

output "ec2_transit_gateway_route_table_propagation_ids" {
  description = "List of EC2 Transit Gateway Route Table Propagation identifiers"
  value       = [for k, v in aws_ec2_transit_gateway_route_table_propagation.rt_propagation : v.id]
}

output "ec2_transit_gateway_route_table_propagation" {
  description = "Map of EC2 Transit Gateway Route Table Propagation attributes"
  value       = aws_ec2_transit_gateway_route_table_propagation.rt_propagation
}
