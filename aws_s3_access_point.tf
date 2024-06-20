resource "aws_s3_access_point" "aws_s3_access_point" {
  for_each = var.aws_region.default ? {default : true} : {}
  bucket = aws_s3_bucket.aws_s3_bucket.id
  name   = random_string.aws_s3_access_point[each.key].result

  public_access_block_configuration  {
    block_public_acls       = false
    block_public_policy     = false
    ignore_public_acls      = false
    restrict_public_buckets = false
  }
}