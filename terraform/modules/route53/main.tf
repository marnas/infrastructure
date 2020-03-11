data "aws_route53_zone" "route_zone" {
  name         = "${var.domain_name}."
  private_zone = false
}

resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.route_zone.zone_id
  name    = "${var.environment}.${var.domain_name}"
  type    = "A"

  alias {
    name                   = var.cloudfront_domain
    zone_id                = var.cloudfront_zone
    evaluate_target_health = true
  }
}
