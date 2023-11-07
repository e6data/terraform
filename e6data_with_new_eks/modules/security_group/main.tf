resource "aws_security_group" "allow_ports" {
  name        = var.sec_grp_name
  vpc_id      = var.vpc_id

  dynamic "ingress" {
    for_each = var.service_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.cidr_block
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
      Name = var.sec_grp_name
    }
  
  lifecycle {
    ignore_changes = [ingress]
  }
}
