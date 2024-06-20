resource "aws_alb_target_group" "aws_alb_target_group" {
  vpc_id   = aws_vpc.aws_vpc.id
  port     = 80
  protocol = "HTTP"
  protocol_version = "HTTP1"
  target_type = "instance"

  health_check {
    enabled             = true
    interval            = 30
    timeout             = 5
    path                = "/"
    protocol            = "HTTP"
    matcher             = "200"
    port                = "traffic-port"
  }
}