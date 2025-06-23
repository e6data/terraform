resource "aws_lb_target_group" "eks_target_group" {
  name        = "eks-lb-${var.eks_cluster_name}"  
  port        = var.port
  protocol    = "TCP"
  vpc_id      = var.vpc_id
  target_type = "ip"

  depends_on = [
    aws_lb.eks_nlb
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group_attachment" "target_group_attachment" {
  for_each = data.aws_network_interface.eks_nic

  target_group_arn = aws_lb_target_group.eks_target_group.arn
  target_id        = each.value.private_ips[0]
}

data "aws_network_interfaces" "eks_nic" {
  filter {
    name   = "description"
    values = ["Amazon EKS ${var.eks_cluster_name}"]
  }
}

data "aws_network_interface" "eks_nic" {
  for_each = toset(data.aws_network_interfaces.eks_nic.ids)
  id       = each.key
}