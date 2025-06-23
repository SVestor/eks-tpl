resource "helm_release" "ingress_nginx_external" {
  name = "external"

  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.12.2"
  namespace        = "ingress-nginx"
  create_namespace = true

  values = [
    file("${path.module}/helm_values/ingress-nginx.yaml")
  ]

  set {
    name  = "controller.metrics.enabled"
    value = "true"
  }

  # (optional) Used for NLB proxy protocol (to get client ip)

  set {
    name  = "controller.config.use-proxy-protocol"
    value = "true"
  }

  # set {
  #   name  = "controller.config.use-forwarded-headers"
  #   value = "true"
  # }

  depends_on = [helm_release.aws_lbc]
}
  