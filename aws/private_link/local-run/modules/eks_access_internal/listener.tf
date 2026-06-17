resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.eks_nlb.arn

  protocol          = "TCP"
  port              = var.port

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eks_target_group.arn
  }
}