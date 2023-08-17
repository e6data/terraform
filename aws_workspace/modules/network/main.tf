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
