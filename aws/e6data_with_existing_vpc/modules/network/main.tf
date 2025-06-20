# Get object aws_vpc by vpc_id
data "aws_vpc" "vpc" {
  id = var.vpc_id
}

# data "aws_availability_zones" "available" {
#   state         = "available"
#   exclude_names = var.excluded_az
# }

# locals {
#   subnet_count = length(flatten(data.aws_availability_zones.available.*.names))

  # public_subnets = {
  #   for index, subnet in data.aws_availability_zones.available.names : index =>
  #   {
  #     az = data.aws_availability_zones.available.names[index]
  #     cidr = cidrsubnet(
  #       data.aws_vpc.vpc.cidr_block,
  #       8,
  #       150 + index
  #     )
  #   }
  # }

  # private_subnets = {
  #   for index, subnet in data.aws_availability_zones.available.names : index =>
  #   {
  #     az = data.aws_availability_zones.available.names[index]
  #     cidr = cidrsubnet(
  #       data.aws_vpc.vpc.cidr_block,
  #       8,
  #       200 + index
  #     )
  #   }
  # }
# }