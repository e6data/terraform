resource "aws_subnet" "private" {

  for_each = toset(var.private_subnet_cidr)

  vpc_id            = data.aws_vpc.vpc.id
  availability_zone = element(data.aws_availability_zones.available.names, index(var.private_subnet_cidr, each.value))
  cidr_block        = each.value

  map_public_ip_on_launch = true

  tags = {
    Name = format("%s-%s-private-subnet-%s", var.env, var.workspace_name, element(data.aws_availability_zones.available.names, index(var.private_subnet_cidr, each.value)))
    type = "private"
  }

  lifecycle {
    ignore_changes = [tags]
  }

}

resource "aws_route_table" "private_route_table" {
  vpc_id = data.aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name = "${var.env}-private"
  }

  lifecycle {
    ignore_changes = [route]
  }
}

resource "aws_route_table_association" "private_subnet_assoc" {
  for_each = aws_subnet.private

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_route_table.id
}
