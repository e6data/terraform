resource "aws_subnet" "public" {
  for_each = local.public_subnets

  vpc_id            = aws_vpc.vpc.id
  availability_zone = each.value.az
  cidr_block = each.value.cidr

  map_public_ip_on_launch = true

  tags = {
    Name = format("%s-%s-public-subnet-%s", var.env, var.workspace_name, each.value.az)
    type = "public" 
  }

  lifecycle {
    ignore_changes = [tags]
  }

  depends_on = [ aws_vpc.vpc ]
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ig.id
  }

  tags = {
    Name = "${var.env}-public"
  }

  lifecycle {
    ignore_changes = [route]
  }
}

resource "aws_route_table_association" "pub_subnet_assoc" {
  for_each = local.public_subnets

  subnet_id      = aws_subnet.public[each.key].id
  route_table_id = aws_route_table.public_route_table.id
}
