resource "aws_s3_bucket" "aws_s3_bucket" {
  bucket = random_string.aws_s3_bucket.result
  force_destroy = true
}