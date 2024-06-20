resource "aws_s3_bucket_ownership_controls" "aws_s3_bucket_ownership_controls" {
  bucket = aws_s3_bucket.aws_s3_bucket.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}