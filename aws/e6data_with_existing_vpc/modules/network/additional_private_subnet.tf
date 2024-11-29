# Conditional VPC CIDR block association
resource "aws_vpc_ipv4_cidr_block_association" "additional_cidr" {
  count = length(var.additional_cidr_block) > 0 ? 1 : 0

  vpc_id     = data.aws_vpc.vpc.id
  cidr_block = var.additional_cidr_block
}

# Conditional subnets creation (only if additional CIDR block exists)
resource "aws_subnet" "additional_private" {
  for_each = length(var.additional_cidr_block) > 0 ? local.additional_private_subnets : {}

  vpc_id            = data.aws_vpc.vpc.id
  availability_zone = each.value.az
  cidr_block        = each.value.cidr

  map_public_ip_on_launch = false

  tags = {
    Name = format("%s-%s-additional-private-subnet-%s", var.env, var.workspace_name, each.value.az)
    type = "private"
  }

  lifecycle {
    ignore_changes = [tags]
  }

  depends_on = [data.aws_vpc.vpc]
}

# Conditional route table association (only if additional CIDR block exists)
resource "aws_route_table_association" "additional_private_subnet_assoc" {
  for_each = length(var.additional_cidr_block) > 0 ? local.additional_private_subnets : {}

  subnet_id      = aws_subnet.additional_private[each.key].id
  route_table_id = aws_route_table.private_route_table.id
}
