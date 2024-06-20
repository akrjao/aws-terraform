resource "aws_alb_listener" "aws_alb_listener" {
  load_balancer_arn = aws_alb.aws_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.aws_alb_target_group.arn
  }
}