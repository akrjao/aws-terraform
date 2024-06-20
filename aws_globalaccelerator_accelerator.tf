resource "aws_globalaccelerator_accelerator" "aws_globalaccelerator_accelerator" {
  for_each = var.aws_region.default ? {default : true} : {}
  name            = random_string.aws_globalaccelerator_accelerator[each.key].result
  ip_address_type = "IPV4"
  enabled         = true
}