resource "aws_lb_target_group" "eks_target_group" {
  name        = "lb-int-${var.eks_cluster_name}"  
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
  for_each = var.eks_nic

  target_group_arn = aws_lb_target_group.eks_target_group.arn
  target_id        = each.value.private_ips[0]
}