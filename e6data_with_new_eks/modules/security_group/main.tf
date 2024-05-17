resource "aws_security_group" "allow_ports" {
  name        = var.sec_grp_name
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port        = ingress.value.from_port
      to_port          = ingress.value.to_port
      protocol         = ingress.value.protocol
      self             = ingress.value.self
      cidr_blocks      = ingress.value.cidr_blocks
    }
  }

  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port        = egress.value.from_port
      to_port          = egress.value.to_port
      protocol         = egress.value.protocol
      self             = egress.value.self
      cidr_blocks      = egress.value.cidr_blocks
    }
  }

  tags = {
      Name = var.sec_grp_name
    }
  
  lifecycle {
    ignore_changes = [ingress]
  }
}