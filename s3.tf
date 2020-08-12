resource "aws_s3_bucket" "hirokihello_front" {
  # bucket name
  bucket = var.domain_name
  versioning {
    enabled = true
  }

  website {
    index_document = "index.html"
  }
}

# とりあえずガバガバで実装
resource "aws_s3_bucket_public_access_block" "hirokihello_front" {
  bucket = aws_s3_bucket.hirokihello_front.id
  block_public_acls = false
  block_public_policy = true
  ignore_public_acls = false
  restrict_public_buckets = true
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.hirokihello_front.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }

  statement {
    actions   = ["s3:ListBucket"]
    resources = ["${aws_s3_bucket.hirokihello_front.arn}"]

    principals {
      type        = "AWS"
      identifiers = ["${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}"]
    }
  }
}

resource "aws_s3_bucket_policy" "hirokihello_front" {
  bucket = "${aws_s3_bucket.hirokihello_front.id}"
  policy = "${data.aws_iam_policy_document.s3_policy.json}"
}

# log bucket
resource "aws_s3_bucket" "alb_log_hirokihello_front" {
  bucket = "alb-log-hirokihello-front-${var.stage}"

  lifecycle_rule {
    enabled = true

    expiration {
      days = "180"
    }
  }
}

# bucket policy definition
# identifierは書き込み用アカウントを示す固定値
resource "aws_s3_bucket_policy" "alb_log" {
  bucket = aws_s3_bucket.alb_log_hirokihello_front.id
  policy = data.aws_iam_policy_document.alb_log.json
}

data "aws_iam_policy_document" "alb_log" {
  statement {
    effect = "Allow"
    actions = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${aws_s3_bucket.alb_log_hirokihello_front.id}/*"]

    principals {
      type = "AWS"
      identifiers = ["582318560864"]
    }
  }
}
