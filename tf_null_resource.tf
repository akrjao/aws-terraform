resource "null_resource" "aws_globalaccelerator_listener_arn_setter" {
  for_each = var.aws_region.default ? {default : true} : {}
  provisioner "local-exec" {
    command = "echo ${aws_globalaccelerator_listener.aws_globalaccelerator_listener[each.key].id}>> ${path.module}/crossover/aws_globalaccelerator_listener.arn"
    on_failure = fail
  }
}

resource "null_resource" "aws_s3_bucket_arn_setter" {
  depends_on = [aws_s3_bucket_versioning.aws_s3_bucket_versioning]
  for_each = var.aws_region.default ? {} : {default : true}
  provisioner "local-exec" {
    command = "echo ${aws_s3_bucket.aws_s3_bucket.arn}>> ${path.module}/crossover/aws_s3_bucket.arn"
    on_failure = fail
  }
}


resource "null_resource" "user_data_setter_via_powershell" {
  for_each = (var.aws_region.default && local.is_windows) ? aws_s3_object.aws_s3_object: {}
  depends_on = [aws_cloudfront_distribution.aws_cloudfront_distribution, local.is_windows]
  provisioner "local-exec" {
    command = "'\nsudo echo ''<img src=http://${aws_cloudfront_distribution.aws_cloudfront_distribution["default"].domain_name}/${each.value.key}>'' >> ''/var/www/html/index.html'';' | Out-File ${path.module}/userdata/user_data.sh -Encoding 'UTF8' -Append -NoNewline"
    interpreter = ["powershell.exe", "-Command"]
    on_failure = continue
  }
}

resource "null_resource" "user_data_setter_via_bash_zsh" {
  for_each = (var.aws_region.default && !local.is_windows) ? aws_s3_object.aws_s3_object: {}
  depends_on = [aws_cloudfront_distribution.aws_cloudfront_distribution, local.is_windows]
  provisioner "local-exec" {
    command = "echo 'sudo echo '\"'<img src=http://${aws_cloudfront_distribution.aws_cloudfront_distribution["default"].domain_name}/${each.value.key}>'\"' >> '\"'/var/www/html/index.html'\"';' >> ${path.module}/userdata/user_data.sh"
    on_failure = continue
  }
}

resource "null_resource" "aws_globalaccelerator_listener_arn_unsetter_via_powershell" {
  for_each = (var.aws_region.default && local.is_windows) ? {default : true} : {}
  provisioner "local-exec" {
    when = destroy
    command = "Clear-Content -Path '${path.module}/crossover/aws_globalaccelerator_listener.arn'"
    interpreter = ["powershell.exe", "-Command"]
    on_failure = continue
  }
}

resource "null_resource" "aws_globalaccelerator_listener_arn_unsetter_via_bash_zsh" {
  for_each = (var.aws_region.default && !local.is_windows) ? {default : true} : {}
  provisioner "local-exec" {
    when = destroy
    command = "> ${path.module}/crossover/aws_globalaccelerator_listener.arn"
    on_failure = continue
  }
}

resource "null_resource" "aws_s3_bucket_arn_unsetter_via_powershell" {
  for_each = (var.aws_region.default && local.is_windows) ? {default : true} : {}
  provisioner "local-exec" {
    when = destroy
    command = "Clear-Content -Path '${path.module}/crossover/aws_s3_bucket.arn'"
    interpreter = ["powershell.exe", "-Command"]
    on_failure = continue
  }
}

resource "null_resource" "aws_s3_bucket_arn_unsetter_via_bash_zsh" {
  for_each = (var.aws_region.default && !local.is_windows) ? {default : true} : {}
  provisioner "local-exec" {
    when = destroy
    command = "> ${path.module}/crossover/aws_s3_bucket.arn"
    on_failure = continue
  }
}

resource "null_resource" "user_data_unsetter_via_powershell" {
  for_each = (var.aws_region.default && local.is_windows) ? aws_s3_object.aws_s3_object : {}
  provisioner "local-exec" {
    when = destroy
    command = "$file = Get-Content -Path '${path.module}/userdata/user_data.sh'; $file = $file | Where-Object {$_ -notlike '*cloudfront*'}; $file = $file  | Where-Object { $_ -ne '' }; Set-Content '${path.module}/userdata/user_data.sh' -Value $file"
    interpreter = [ "powershell.exe", "-Command" ]
    on_failure = continue
  }
}

resource "null_resource" "user_data_unsetter_via_bash_zsh" {
  for_each = (var.aws_region.default && !local.is_windows) ? aws_s3_object.aws_s3_object: {}
  provisioner "local-exec" {
    when = destroy
    command = "sed -i \"/cloudfront/d\" ${path.module}/userdata/user_data.sh; sed -i '/^$/d' ${path.module}/userdata/user_data.sh;"
    on_failure = continue
  }
}
