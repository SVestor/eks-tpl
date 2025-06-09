# grafana render template

data "helm_template" "grafana" {
  name = "grafana"

  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  namespace        = "monitoring"
  create_namespace = true
  version          = "9.2.2"

  set {
    name  = "image.tag"
    value = "12.0.1"
  }

  set {
    name  = "admin.existingSecret"
    value = "grafana"
  }

  set {
    name  = "persistence.enabled"
    value = "true"
  }

  set {
    name  = "persistence.storageClassName"
    value = "gp3-monitoring"
  }

  set {
    name  = "persistence.size"
    value = "8Gi"
  }
}

resource "local_file" "grafana_manifests" {
  for_each = data.helm_template.grafana.manifests

  filename = "target/${each.key}"
  content  = each.value
}
