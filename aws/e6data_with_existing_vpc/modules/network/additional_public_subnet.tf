# Conditional public subnets creation (only if additional CIDR block exists)
resource "aws_subnet" "additional_public" {
  for_each = length(var.additional_cidr_block) > 0 ? local.additional_public_subnets : {}

  vpc_id            = data.aws_vpc.vpc.id
  availability_zone = each.value.az
  cidr_block        = each.value.cidr

  map_public_ip_on_launch = true

  tags = {
    Name = format("%s-%s-additional-public-subnet-%s", var.env, var.workspace_name, each.value.az)
    type = "public"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  depends_on = [data.aws_vpc.vpc]
}

# Conditional route table association for public subnets (only if additional CIDR block exists)
resource "aws_route_table_association" "additional_pub_subnet_assoc" {
  for_each = length(var.additional_cidr_block) > 0 ? local.additional_public_subnets : {}

  subnet_id      = aws_subnet.additional_public[each.key].id
  route_table_id = aws_route_table.public_route_table.id
}
