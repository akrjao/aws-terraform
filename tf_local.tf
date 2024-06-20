locals {
  aws_s3_bucket_arn_file = split("\n", file("${path.module}/crossover/aws_s3_bucket.arn"))
  aws_s3_bucket_arn_file_trimmed = [for k in local.aws_s3_bucket_arn_file : trimspace(k)]
  aws_s3_bucket_arn_file_filtered = [for k in local.aws_s3_bucket_arn_file_trimmed : k if k != ""]
  aws_globalaccelerator_listener_arn_file = split("\n", file("${path.module}/crossover/aws_globalaccelerator_listener.arn"))
  aws_globalaccelerator_listener_arn_file_trimmed = [for k in local.aws_globalaccelerator_listener_arn_file : trimspace(k)]
  is_windows = strcontains(abspath(path.module), ":") ? true : false
}