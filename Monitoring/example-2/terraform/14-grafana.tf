resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
    labels = {
      monitoring = "prometheus"
    }
  }
}

resource "kubernetes_namespace" "grafana" {
  metadata {
    name = "grafana"
    labels = {
      monitoring = "grafana"
    }
  }
}

resource "kubernetes_secret_v1" "grafana" {
  metadata {
    name      = "grafana"
    namespace = "grafana"
  }

  data = {
    admin-user     = var.grafana_admin_user
    admin-password = var.grafana_admin_password
  }

  type = "Opaque"
}

resource "helm_release" "grafana" {
  name = "grafana"

  repository = "https://grafana.github.io/helm-charts"
  chart      = "grafana"
  namespace  = "grafana"
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

  values = [
    file("${path.module}/helm_values/grafana.yaml")
  ]

  depends_on = [
    kubernetes_storage_class_v1.gp3_monitoring,
    kubernetes_secret_v1.grafana
  ]
}

resource "kubernetes_config_map_v1" "grafana_dashboard_prometheus" {
  metadata {
    name      = "grafana-dashboard-prometheus"
    namespace = "grafana"
    labels = {
      grafana_dashboard = "1" # This label enables auto-loading
    }
  }

  data = {
    "prometheus-dashboard.json" = file("${path.module}/../grafana/dashboards/prometheus-dashboard.json")
  }

  depends_on = [
    helm_release.grafana
  ]
}
