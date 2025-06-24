data "aws_network_interfaces" "eks_nic" {
  filter {
    name   = "description"
    values = ["Amazon EKS ${module.eks.cluster_name}"]
  }
}

data "aws_network_interface" "eks_nic" {
  for_each = toset(data.aws_network_interfaces.eks_nic.ids)
  id       = each.key
}

resource "aws_vpc_endpoint_connection_accepter" "accept" {
  vpc_endpoint_service_id = module.eks_internal_endpoint_service.vpc_endpoint_service_id
  vpc_endpoint_id         = aws_vpc_endpoint.eks_endpoint.id

  depends_on = [
    module.eks,
    module.eks_internal_endpoint_service,
    aws_vpc_endpoint.eks_endpoint
  ]
}

module "eks_internal_endpoint_service" {
  source = "./modules/eks_access_internal"

  eks_cluster_name = module.eks.cluster_name
  vpc_id            = module.network.vpc_id
  subnet_ids = module.network.private_subnet_ids
  cost_tags = var.cost_tags
  aws_region = var.aws_region
  eks_nic  = data.aws_network_interface.eks_nic

  depends_on = [
    module.eks
  ]
}

resource "aws_vpc_endpoint" "eks_endpoint" {
  vpc_id            = var.vpc_id
  service_name      = module.eks_internal_endpoint_service.endpoint_service_name
  vpc_endpoint_type = "Interface"
  subnet_ids        = var.public_subnet_id
  security_group_ids = [
    aws_security_group.endpoint_sg.id
  ]

  depends_on = [ module.eks_internal_endpoint_service, module.eks ]
}

resource "aws_security_group" "endpoint_sg" {
  name        = "e6data_eks_temp_access_terraform"
  description = "Allow endpoint inbound traffic"
  vpc_id      = var.vpc_id

  ingress {
    description      = "TLS from VPC"
    from_port        = 443
    to_port          = 443
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  depends_on = [ module.eks ]
}
