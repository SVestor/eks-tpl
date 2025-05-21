resource "aws_acm_certificate" "flask_app_cert" {
  domain_name       = local.flask_app_hostname
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "primary" {
  name = "${var.dns_zone_name}."
}

# Use certificate domain validation options to create CNAME records in Route53
resource "aws_route53_record" "flask_app_cert_validation" {
  for_each = {
    for dvo in aws_acm_certificate.flask_app_cert.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.primary.zone_id
}

resource "aws_acm_certificate_validation" "flask_app_cert" {
  certificate_arn         = aws_acm_certificate.flask_app_cert.arn
  validation_record_fqdns = [for record in aws_route53_record.flask_app_cert_validation : record.fqdn]
}

