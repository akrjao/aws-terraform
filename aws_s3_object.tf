resource "aws_s3_object" "aws_s3_object" {
  for_each = var.aws_region.default ? fileset("${path.module}/userdata/static", "*") : []
  key                    = each.value
  bucket                 = aws_s3_bucket.aws_s3_bucket.id
  source                 = "${path.module}/userdata/static/${each.value}"
  server_side_encryption = "AES256"
  depends_on = [aws_s3_bucket_replication_configuration.aws_s3_bucket_replication_configuration]
}