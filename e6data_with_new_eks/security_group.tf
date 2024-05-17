resource "aws_security_group" "eks_security_group" {
  name        = "${local.e6data_workspace_name}-${random_string.random.result}"
  vpc_id      = module.network.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
  }

  egress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    self        = true
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    self        = true
  }

  tags = {
      Name = "${local.e6data_workspace_name}-${random_string.random.result}"
    }
  
  lifecycle {
    ignore_changes = [ingress]
  }
}
