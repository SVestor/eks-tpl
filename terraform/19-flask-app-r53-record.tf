# This resource is used to get the ALB ingress data
# and create a Route53 record for it
data "aws_lb" "ingress" {
  name = local.flask_app_ingress_alb_name

  depends_on = [null_resource.flask_ingress_apply]
}

resource "aws_route53_record" "flask_app" {
  name    = local.flask_app_hostname
  type    = "A"
  zone_id = data.aws_route53_zone.primary.zone_id

  alias {
    name                   = data.aws_lb.ingress.dns_name
    zone_id                = data.aws_lb.ingress.zone_id
    evaluate_target_health = true
  }
}
