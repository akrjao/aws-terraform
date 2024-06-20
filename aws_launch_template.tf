resource "aws_launch_template" "aws_launch_template" {
  depends_on = [data.template_file.user_data]
  image_id = var.aws_region.ami
  instance_type = var.aws_region.instance_type
  user_data = base64encode(data.template_file.user_data.rendered)
  
  network_interfaces {
    associate_public_ip_address = true
    security_groups = [aws_security_group.aws_security_group.id]
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "optional"
    http_put_response_hop_limit = 1
    http_protocol_ipv6 = "disabled" 
    instance_metadata_tags      = "enabled"
  }

}