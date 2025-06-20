# resource "aws_subnet" "private" {

#   for_each = local.private_subnets

#   vpc_id            = data.aws_vpc.vpc.id
#   availability_zone = each.value.az
#   cidr_block        = each.value.cidr

#   map_public_ip_on_launch = true

#   tags = {
#     Name = format("%s-%s-private-subnet-%s", var.env, var.workspace_name, each.value.az)
#     type = "private"
#   }

#   lifecycle {
#     ignore_changes = [tags]
#   }

# }

# resource "aws_route_table" "private_route_table" {
#   vpc_id = data.aws_vpc.vpc.id

#   for_each = {
#     nat_1 = aws_nat_gateway.nat_gw_1.id
#     nat_2 = aws_nat_gateway.nat_gw_2.id
#   }

#   route {
#     cidr_block     = "0.0.0.0/0"
#     nat_gateway_id = each.value
#   }

#   tags = {
#     Name = "${var.env}-private-${each.key}"
#   }

#   lifecycle {
#     ignore_changes = [route]
#   }
# }

# resource "aws_route_table_association" "private_subnet_assoc" {
#   for_each = local.private_subnets

#   subnet_id      = aws_subnet.private[each.key].id
#   route_table_id = each.key % 2 == 0 ? aws_route_table.private_route_table["nat_1"].id : aws_route_table.private_route_table["nat_2"].id
# }

# data "aws_subnets" "all" {
#   filter {
#     name   = "vpc-id"
#     values = [data.aws_vpc.vpc.id]
#   }
# }

# data "aws_subnet" "each" {
#   for_each = toset(data.aws_subnets.all.ids)
#   id       = each.value
# }

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.vpc.id]
  }

  filter {
    name   = "tag:Tier"
    values = ["private"]
  }
}
