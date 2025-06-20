output "subnet_ids" {
  description = "IDs of all subnets"
  value = data.aws_subnets.private.ids
}

output "vpc_id" {
  description = "The vpc ID"
  value       = data.aws_vpc.vpc.id
}

output "vpc_cidr" {
  description = "The vpc CIDR"
  value       = data.aws_vpc.vpc.cidr_block
}

output "private_subnet_ids" {
  value = data.aws_subnets.private.ids
}