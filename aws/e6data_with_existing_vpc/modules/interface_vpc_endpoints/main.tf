resource "aws_vpc_endpoint" "endpoint" {
  vpc_id            = var.vpc_id
  service_name      = var.service_name
  vpc_endpoint_type = var.vpc_endpoint_type
  subnet_ids        = var.subnet_ids
  private_dns_enabled = false
  security_group_ids = [
    aws_security_group.endpoint_sg.id,
  ]

   tags = {
    Name = "${var.name}-privatelink-endpoint"
  }
}

resource "aws_security_group" "endpoint_sg" {
  name        = "${var.name}-${var.workspace_name}-endpoint-sg"
  description = "Allow endpoint inbound traffic"
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      description = lookup(ingress.value, "description", "Allow traffic")
      from_port   = lookup(ingress.value, "from_port", 0)
      to_port     = lookup(ingress.value, "to_port", 0)
      protocol    = lookup(ingress.value, "protocol", "-1")
      cidr_blocks = lookup(ingress.value, "cidr_blocks", ["0.0.0.0/0"])
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = lookup(egress.value, "from_port", 0)
      to_port     = lookup(egress.value, "to_port", 0)
      protocol    = lookup(egress.value, "protocol", "-1")
      cidr_blocks = lookup(egress.value, "cidr_blocks", ["0.0.0.0/0"])
    }
  }
}

