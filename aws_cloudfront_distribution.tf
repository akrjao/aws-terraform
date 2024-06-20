resource "aws_cloudfront_distribution" "aws_cloudfront_distribution" {
  for_each = var.aws_region.default ? {default : true} : {}
  origin {
    domain_name              = aws_s3_bucket.aws_s3_bucket.bucket_regional_domain_name
    origin_id                = aws_s3_bucket.aws_s3_bucket.id
    origin_shield {
      enabled = true
      origin_shield_region = var.aws_region.code
    }
  }
  
  enabled             = true
  is_ipv6_enabled     = false

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD", "OPTIONS"]
    target_origin_id = aws_s3_bucket.aws_s3_bucket.id
    compress = true
    cache_policy_id = data.aws_cloudfront_cache_policy.aws_cloudfront_cache_policy[each.key].id
    viewer_protocol_policy = "allow-all"
  }

  price_class = "PriceClass_All"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

}