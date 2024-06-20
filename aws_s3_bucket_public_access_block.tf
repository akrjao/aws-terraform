resource "aws_s3_bucket_public_access_block" "aws_s3_bucket_public_access_block_default_region" {
  for_each = var.aws_region.default ? {default : true} : {}
  bucket = aws_s3_bucket.aws_s3_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_public_access_block" "aws_s3_bucket_public_access_block_non_default_region" {
  for_each = var.aws_region.default ? {} : {default : true}
  bucket = aws_s3_bucket.aws_s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}