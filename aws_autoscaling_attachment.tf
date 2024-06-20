resource "aws_autoscaling_attachment" "aws_autoscaling_attachment" {
  autoscaling_group_name = aws_autoscaling_group.aws_autoscaling_group.name
  lb_target_group_arn    = aws_alb_target_group.aws_alb_target_group.arn
}