resource "aws_subnet" "private" {
  
  for_each = local.private_subnets

  vpc_id            = aws_vpc.vpc.id
  availability_zone = each.value.az
  cidr_block = each.value.cidr

  map_public_ip_on_launch = true

  tags = {
    Name = format("%s-%s-private-subnet-%s", var.env, var.workspace_name, each.value.az)
    type = "private" 
  }

  lifecycle {
    ignore_changes = [tags]
  }

  depends_on = [ aws_vpc.vpc ]
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
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
  for_each = local.private_subnets

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private_route_table.id
}
