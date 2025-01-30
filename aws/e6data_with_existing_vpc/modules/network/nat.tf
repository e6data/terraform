resource "aws_eip" "nat" {
  tags = {
    Name = "${var.env}-${var.workspace_name}-nat-EIP"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = values(aws_subnet.public)[1].id
  tags = {
    Name = "${var.env}-${var.workspace_name}-nat-GW"
  }
}
