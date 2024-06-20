variable "AWS_ACCESS_KEY" {
  type = string
}

variable "AWS_SECRET_KEY" {
  type = string
}

variable "aws_autoscaling_policy" {
  type = object({
    target_value = number
  })
}

variable "aws_autoscaling_group" {
  type = object({
    desired_capacity = number
    minimum_capacity = number
    maximum_capacity = number
  })
}