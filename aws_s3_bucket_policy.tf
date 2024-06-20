resource "aws_s3_bucket_policy" "aws_s3_bucket_policy" {
  for_each = var.aws_region.default ? {default : true} : {}
  bucket = aws_s3_bucket.aws_s3_bucket.id
  policy = data.aws_iam_policy_document.bucket_access[each.key].json
  depends_on = [aws_s3_bucket_public_access_block.aws_s3_bucket_public_access_block_default_region]
}