provider "aws" {
  alias = "virginia"
  region = "us-east-1"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = var.s3_origin_domain
    origin_id   = "S3-${var.s3_bucket_name}"
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${var.s3_bucket_name}"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  aliases = [ "${var.domain_name}" ]

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn = aws_acm_certificate_validation.cert.certificate_arn
    ssl_support_method  = "sni-only"
  }
}

resource "aws_acm_certificate" "cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  provider          = aws.virginia

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "zone" {
  name         = "${var.route53_zone}."
  private_zone = false
}

resource "aws_route53_record" "cert_validation" {
  name    = aws_acm_certificate.cert.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.cert.domain_validation_options.0.resource_record_type
  zone_id = data.aws_route53_zone.zone.id
  records = ["${aws_acm_certificate.cert.domain_validation_options.0.resource_record_value}"]
  ttl     = 60
}

resource "aws_acm_certificate_validation" "cert" {
  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = ["${aws_route53_record.cert_validation.fqdn}"]
}
