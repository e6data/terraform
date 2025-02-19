resource "aws_eip" "nat_1" {
  tags = {
    Name = "${var.env}-${var.workspace_name}-nat-1-EIP"
  }
}

resource "aws_nat_gateway" "nat_gw_1" {
  allocation_id = aws_eip.nat_1.id
  subnet_id     = aws_subnet.public[0].id
  tags = {
    Name = "${var.env}-${var.workspace_name}-nat-1-GW"
  }
}

resource "aws_eip" "nat_2" {
  tags = {
    Name = "${var.env}-${var.workspace_name}-nat-2-EIP"
  }
}

resource "aws_nat_gateway" "nat_gw_2" {
  allocation_id = aws_eip.nat_2.id
  subnet_id     = aws_subnet.public[1].id
  tags = {
    Name = "${var.env}-${var.workspace_name}-nat-2-GW"
  }
}
