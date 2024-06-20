resource "aws_alb" "aws_alb" {
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.aws_security_group.id]
  subnets            = [aws_subnet.aws_subnet_a.id, aws_subnet.aws_subnet_b.id]
}