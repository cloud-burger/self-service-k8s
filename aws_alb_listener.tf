resource "aws_lb_listener" "eks_listener" {
  load_balancer_arn = aws_alb.eks_alb.arn
  port              = 8080
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.eks_target_group.arn
  }
}
