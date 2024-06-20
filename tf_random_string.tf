resource "random_string" "aws_s3_access_point" {
  for_each = (var.aws_region.default) ? {default : true} : {}
  length = 33
  special = false
  upper = false
  numeric = false
}
resource "random_string" "aws_s3_bucket" {
  length = 63
  special = false
  upper = false
}

resource "random_string" "aws_autoscaling_policy" {
  length = 254
  special = false
  upper = false
}

resource "random_string" "aws_globalaccelerator_accelerator" {
  for_each = (var.aws_region.default) ? {default : true} : {}
  length = 63
  special = false
  upper = false
}

resource "random_string" "aws_iam_policy" {
  for_each = (var.aws_region.default) ? {default : true} : {}
  length = 127
  special = false
  upper = false
}

resource "random_string" "aws_iam_role" {
  for_each = (var.aws_region.default) ? {default : true} : {}
  length = 63
  special = false
  upper = false
}