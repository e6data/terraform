resource "aws_msk_vpc_connection" "msk_connect" {
  authentication     = "SASL_SCRAM"
  target_cluster_arn = var.msk_cluster_arn
  vpc_id             = module.network.vpc_id
  client_subnets     = module.network.private_subnet_ids
  security_groups    = [aws_security_group.msk_vpc_connection.id]
}

resource "aws_security_group" "msk_vpc_connection" {
  name        = "msk-vpc-connection-sg"
  description = "Allow ports 14098-14100 for MSK VPC connection"
  vpc_id      = module.network.vpc_id

  ingress {
    from_port   = 14000
    to_port     = 14100
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "msk-vpc-connection-sg"
  }
}
