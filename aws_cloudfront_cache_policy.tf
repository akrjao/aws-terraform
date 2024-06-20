data "aws_cloudfront_cache_policy" "aws_cloudfront_cache_policy" {
  for_each = var.aws_region.default ? {default : true} : {}
  name = "Managed-CachingOptimized"
}