# Get object aws_vpc by vpc_id
data "aws_vpc" "vpc" {
  id = var.vpc_id
}

# resource "aws_internet_gateway" "ig" {
#   vpc_id = data.aws_vpc.vpc.id

#   tags = {
#     Name = "${var.env}-${var.workspace_name}-IG"
#   }
# }

data "aws_internet_gateway" "ig" {
  filter {
    name   = "attachment.vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_availability_zones" "available" {
  state         = "available"
  exclude_names = var.excluded_az
}

locals {
  subnet_count = length(flatten(data.aws_availability_zones.available.*.names))


  subnet_cidr_blocks = cidrsubnet(
    data.aws_vpc.vpc.cidr_block,
    ceil(log(local.subnet_count * 2, 2)),
    local.subnet_count + 1
  )

  public_subnets = {
    for index, subnet in data.aws_availability_zones.available.names : index =>
    {
      az = data.aws_availability_zones.available.names[index]
      cidr = cidrsubnet(
        data.aws_vpc.vpc.cidr_block,
        8,
        150 + index
      )
    }
  }

  private_subnets = {
    for index, subnet in data.aws_availability_zones.available.names : index =>
    {
      az = data.aws_availability_zones.available.names[index]
      cidr = cidrsubnet(
        data.aws_vpc.vpc.cidr_block,
        8,
        200 + index
      )
    }
  }
}

resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id          = data.aws_vpc.vpc.id
  service_name    = "com.amazonaws.${var.region}.s3"
  route_table_ids = concat([aws_route_table.public_route_table.id], values(aws_route_table.private_route_table)[*].id, [data.aws_vpc.vpc.main_route_table_id])
  tags = {
    Name = "${var.env}-${var.workspace_name}-gw-endpoint"
  }

  depends_on = [aws_route_table.private_route_table, aws_route_table.public_route_table]
}