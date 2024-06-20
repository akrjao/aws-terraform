resource "aws_autoscaling_policy" "aws_autoscaling_policy" {
  name                   = random_string.aws_autoscaling_policy.result
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.aws_autoscaling_group.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = var.aws_autoscaling_policy.target_value
    disable_scale_in = false
  }
}