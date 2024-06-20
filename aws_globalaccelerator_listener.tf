resource "aws_globalaccelerator_listener" "aws_globalaccelerator_listener" {
  for_each = var.aws_region.default ? {default : true} : {}
  accelerator_arn = aws_globalaccelerator_accelerator.aws_globalaccelerator_accelerator[each.key].id
  client_affinity = "SOURCE_IP"
  protocol        = "TCP"

  port_range {
    from_port = 80
    to_port   = 80
  }
}