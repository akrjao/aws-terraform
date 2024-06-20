resource "aws_globalaccelerator_endpoint_group" "aws_globalaccelerator_accelerator_endpoint_group_default_region" {
  for_each = var.aws_region.default ? {default : true} : {}
  listener_arn   = aws_globalaccelerator_listener.aws_globalaccelerator_listener[each.key].id
  endpoint_group_region = var.aws_region.code
  traffic_dial_percentage = 100

  endpoint_configuration {
    endpoint_id = aws_alb.aws_alb.arn
    client_ip_preservation_enabled = false
    weight      = 100
  }
}

resource "aws_globalaccelerator_endpoint_group" "aws_globalaccelerator_accelerator_endpoint_group_non_default_region" {
  for_each = var.aws_region.default ? {} : {default : true}
  listener_arn   = local.aws_globalaccelerator_listener_arn_file_trimmed[0]
  endpoint_group_region = var.aws_region.code
  traffic_dial_percentage = 100

  endpoint_configuration {
    endpoint_id = aws_alb.aws_alb.arn
    client_ip_preservation_enabled = false
    weight      = 100
  }
}