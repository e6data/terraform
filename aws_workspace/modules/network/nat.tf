resource "aws_eip" "nat" {
  tags = { 
    Name = "${var.env}-NAT-EIP"
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat.id
  subnet_id     = aws_subnet.public[1].id
  tags = {
      Name = "${var.env}-NAT-GW"
  }
}
