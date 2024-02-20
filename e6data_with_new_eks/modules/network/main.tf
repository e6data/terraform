# Get object aws_vpc by vpc_id
resource "aws_vpc" "vpc" {
  cidr_block = var.cidr_block
  enable_dns_hostnames           = true
  enable_dns_support             = true
  tags = {
    Name = "${var.env}-${var.workspace_name}-vpc"
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "${var.env}-${var.workspace_name}-IG"
  }
}

data "aws_availability_zones" "available" {
  state = "available"
  exclude_names = var.excluded_az
}

locals {
  subnet_count = length(flatten(data.aws_availability_zones.available.*.names))


  subnet_cidr_blocks = cidrsubnet(
    var.cidr_block,
    ceil(log(local.subnet_count * 2, 2)),
    local.subnet_count + 1
  )

  public_subnets = {
    for index, subnet in data.aws_availability_zones.available.names : index => 
    {
      az = data.aws_availability_zones.available.names[index]
      cidr = cidrsubnet(
        var.cidr_block,
        ceil(log(local.subnet_count * 2, 2)),
        local.subnet_count + index
      )
    } 
  }

  private_subnets = {
    for index, subnet in data.aws_availability_zones.available.names : index => 
    {
      az = data.aws_availability_zones.available.names[index]
      cidr = cidrsubnet(
        var.cidr_block,
        ceil(log(local.subnet_count * 2, 2)),
        index
      )
    } 
  }
}

resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id       = aws_vpc.vpc.id
  service_name = "com.amazonaws.${var.region}.s3"
  route_table_ids = [aws_route_table.private_route_table.id, aws_route_table.public_route_table.id, aws_vpc.vpc.default_route_table_id]
  tags = {
    Name = "${var.env}-${var.workspace_name}-gw-endpoint"
  }

  depends_on = [ aws_vpc.vpc, aws_route_table.private_route_table, aws_route_table.public_route_table ]
}
