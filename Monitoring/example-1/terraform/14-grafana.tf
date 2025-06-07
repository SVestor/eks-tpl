resource "helm_release" "grafana" {
  name = "grafana"

  repository       = "https://grafana.github.io/helm-charts"
  chart            = "grafana"
  namespace        = "monitoring"
  create_namespace = true
  version          = "9.2.1"

  set {
    name  = "image.tag"
    value = "12.0.0"
  }

  set {
    name  = "adminPassword"
    value = "mySuperSecretPassword"
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

  depends_on = [aws_eks_node_group.eks_main]
}
