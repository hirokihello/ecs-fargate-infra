resource "aws_route53_zone" "hirokihello-private" {
  name = var.domain_name
  comment    = "${var.stage} private"
  vpc {
    vpc_id     = "${aws_vpc.hirokihello.id}"
    vpc_region = "ap-northeast-1"
  }
}

resource "aws_route53_zone" "hirokihello-public" {
  name = var.domain_name
}

resource "aws_route53_record" "hirokihello-front-routing" {
  zone_id = "${aws_route53_zone.hirokihello-public.zone_id}"
  name = var.domain_name
  type = "A"

  alias {
    name = "${aws_cloudfront_distribution.s3_distribution.domain_name}"
    zone_id = "${aws_cloudfront_distribution.s3_distribution.hosted_zone_id}"
    evaluate_target_health = false
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  subject_alternative_names  = ["*.${var.domain_name}"]
  validation_method = "DNS"
  provider          = "aws.virginia"
}

provider "aws" {
  alias  = "virginia"
  region = "us-east-1"
}

resource "aws_route53_record" "api-routing" {
  zone_id = "${aws_route53_zone.hirokihello-public.zone_id}"
  name = "api.${var.domain_name}"
  type = "A"
  set_identifier = "bluuue-public"

  alias {
    name = "${aws_alb.hirokihello.dns_name}"
    zone_id = "${aws_alb.hirokihello.zone_id}"
    evaluate_target_health = false
  }

  geolocation_routing_policy {
    country = "*"
  }
}
