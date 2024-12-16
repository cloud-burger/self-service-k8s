resource "aws_alb" "eks_alb" {
  name               = "ALB-${var.project}"
  internal           = false
  load_balancer_type = "application"
  subnets            = ["${local.aws_private_subnet_id}", "${local.aws_public_subnet_id}"]
  security_groups    = [aws_security_group.eks_security_group.id]
  idle_timeout       = 60
}


