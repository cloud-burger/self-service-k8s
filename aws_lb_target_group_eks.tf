resource "aws_lb_target_group" "eks_target_group" {
  name        = "TG-${var.project}"
  port        = 30201
  target_type = "instance"
  protocol    = "HTTP"

  vpc_id = local.aws_vpc_id


  health_check {
    path    = "/"
    port    = 30201
    matcher = "200"
  }
}

resource "aws_lb_target_group_attachment" "attach" {
  target_group_arn = aws_lb_target_group.eks_target_group.arn
  target_id        = data.aws_instance.ec2.id
  port             = 30201
}
