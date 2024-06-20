resource "aws_autoscaling_group" "aws_autoscaling_group" {
  desired_capacity    = var.aws_autoscaling_group.desired_capacity
  min_size            = var.aws_autoscaling_group.minimum_capacity
  max_size            = var.aws_autoscaling_group.maximum_capacity
  force_delete = true
  health_check_type         = "ELB"
  health_check_grace_period = 300
  vpc_zone_identifier = [aws_subnet.aws_subnet_a.id, aws_subnet.aws_subnet_b.id]
  target_group_arns = [aws_alb_target_group.aws_alb_target_group.arn]

  launch_template {
    id = aws_launch_template.aws_launch_template.id
    version = "$Latest"
  }
}