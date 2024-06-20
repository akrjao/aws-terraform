resource "aws_s3_bucket_server_side_encryption_configuration" "aws_s3_bucket_server_side_encryption_configuration" {
  bucket = aws_s3_bucket.aws_s3_bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}