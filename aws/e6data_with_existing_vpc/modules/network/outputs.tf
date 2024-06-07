output "public_subnet_ids" {
  description = "IDs of the created public subnets"
  value       = [for subnet in aws_subnet.public : subnet.id]
}

output "private_subnet_ids" {
  description = "IDs of the created private subnets"
  value       = [for subnet in aws_subnet.private : subnet.id]
}

output "public_route_table_id" {
  description = "IDs of the created public route tables"
  value       = aws_route_table.public_route_table.id
}

output "private_route_table_id" {
  description = "IDs of the created private route tables"
  value       = aws_route_table.private_route_table.id
}

output "subnet_ids" {
  description = "IDs of all subnets"
  value       = concat([for subnet in aws_subnet.private : subnet.id], [for subnet in aws_subnet.public : subnet.id])
}

output "vpc_id" {
  description = "The vpc ID"
  value       = data.aws_vpc.vpc.id
}

output "vpc_cidr" {
  description = "The vpc CIDR"
  value       = data.aws_vpc.vpc.cidr_block
}
