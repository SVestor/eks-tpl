resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
    labels = {
      monitoring = "prometheus"
    }
  }
}

resource "helm_release" "grafana" {
  name = "grafana"

  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = "monitoring"
  version    = "9.2.2"

  set {
    name  = "admin.existingSecret"
    value = "grafana"
  }

  set {
    name  = "persistence.enabled"
    value = "true"
  }

  # ----------------------------------------------------------------------------------#
  # To make Grafana persistent (Using Statefulset) (Optional - Default is deployment) #
  # ----------------------------------------------------------------------------------#
  set {
    name  = "persistence.type"
    value = "sts"
  }

  set {
    name  = "persistence.storageClassName"
    value = "gp3-monitoring"
  }

  set {
    name  = "persistence.size"
    value = "8Gi"
  }

  depends_on = [kubernetes_storage_class_v1.gp3_monitoring]
}
