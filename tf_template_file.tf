data "template_file" "user_data" {
  depends_on = [null_resource.user_data_setter_via_powershell, null_resource.user_data_setter_via_bash_zsh]
  template = file("${path.module}/userdata/user_data.sh")
}