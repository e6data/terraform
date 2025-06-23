resource "aws_lb" "eks_nlb" {
  name               = "eks-nlb-${var.eks_cluster_name}"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.subnet_ids
}