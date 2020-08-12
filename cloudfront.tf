locals {
  s3_origin_id = "hirokihello-${var.stage}"
}

resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = "origin_access_identity"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  #web_acl_id    = "${aws_waf_web_acl.ip_match_acl.id}"

  origin {
    domain_name = "${aws_s3_bucket.hirokihello_front.bucket_regional_domain_name}"
    origin_id   = "${local.s3_origin_id}"

    s3_origin_config {
      origin_access_identity = "${aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path}"
    }
  }

  aliases = [var.domain_name,]
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "comment"
  default_root_object = "index.html"

  logging_config {
    include_cookies = false
    bucket          = "alb-log-hirokihello-front-${var.stage}.s3.amazonaws.com"
    prefix          = "production-log"
  }

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "${local.s3_origin_id}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_200"

#あとで必要になったら
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  tags = {
    Environment = "production"
  }

  viewer_certificate {
    acm_certificate_arn      = "${aws_acm_certificate.cert.arn}"
    ssl_support_method  = "sni-only"
  }
}
