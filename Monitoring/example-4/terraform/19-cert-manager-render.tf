data "helm_template" "cert-manager" {
  name = "cert-manager"

  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.17.2"
  namespace        = "cert-manager"
  create_namespace = true

  values = [
    file("${path.module}/helm_values/cert-manager.yaml")
  ]

  # (optional) Update file system permissions
  # The reason for this optional step is that on EKS Fargate and on some older versions of EKS you may observe errors
  # related to file permissions. This is a known issue with cert-manager and EKS.

  set {
    name  = "securityContext.fsGroup"
    value = 1001
  }

  set {
    name  = "securityContext.runAsUser"
    value = 1001
  }
}

resource "local_file" "cert-manager_manifests" {
  for_each = data.helm_template.cert-manager.manifests

  filename = "target/${each.key}"
  content  = each.value
}

