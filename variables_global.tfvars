aws_autoscaling_group = {
  desired_capacity = 2
  minimum_capacity = 2
  maximum_capacity = 4
}

aws_autoscaling_policy = {
  target_value = 50.0
}