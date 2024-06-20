output "website_entrypoint" {
    value = var.aws_region.default ? "http://${aws_globalaccelerator_accelerator.aws_globalaccelerator_accelerator["default"].dns_name}" : "Switch to default region via 'terraform workspace select eu-central-1', then execute 'terraform output website_entrypoint'"
}