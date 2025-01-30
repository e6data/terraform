resource "aws_subnet" "public" {
  for_each = toset(var.public_subnet_cidr)

  vpc_id            = data.aws_vpc.vpc.id
  availability_zone = element(data.aws_availability_zones.available.names, index(var.public_subnet_cidr, each.value))
  cidr_block        = each.value

  map_public_ip_on_launch = true

  tags = {
    Name = format("%s-%s-public-subnet-%s", var.env, var.workspace_name, element(data.aws_availability_zones.available.names, index(var.public_subnet_cidr, each.value)))
    type = "public"
  }

  lifecycle {
    ignore_changes = [tags]
  }

}

resource "aws_route_table" "public_route_table" {
  vpc_id = data.aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    # gateway_id = aws_internet_gateway.ig.id
    gateway_id = data.aws_internet_gateway.ig.internet_gateway_id
  }

  tags = {
    Name = "${var.env}-public"
  }

  lifecycle {
    ignore_changes = [route]
  }
}

resource "aws_route_table_association" "pub_subnet_assoc" {
  for_each = aws_subnet.public

  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_route_table.id
}
