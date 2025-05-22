resource "local_file" "flask_ingress_yaml" {
  content = templatefile("../awsLBcontroller_alb/ingress.yaml.tftpl", {
    account_id       = data.aws_caller_identity.current.account_id
    region           = local.region
    ingress_alb_name = local.flask_app_ingress_alb_name
    host_name        = local.flask_app_hostname
    cert_arn         = aws_acm_certificate_validation.flask_app_cert.certificate_arn
  })

  filename = "${path.module}/../awsLBcontroller_alb/3-ingress.yaml"

  depends_on = [helm_release.aws_lbc]
}

# This resource is used to apply the ../awsLBcontroller_alb/* files to create the ALB ingress
resource "null_resource" "flask_ingress_apply" {

  provisioner "local-exec" {
    command = "bash ${path.module}/../awsLBcontroller_alb/commands.sh"
  }

  depends_on = [local_file.flask_ingress_yaml]
}

# Will wait 20 seconds for the ALB to be created
resource "time_sleep" "wait_20_seconds" {
  create_duration = "20s"
  depends_on      = [null_resource.flask_ingress_apply]
}
