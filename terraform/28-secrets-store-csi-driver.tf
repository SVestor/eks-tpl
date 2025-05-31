resource "helm_release" "secrets_store_csi_driver" {
  name = "secrets-store-csi-driver"

  repository = "https://kubernetes-sigs.github.io/secrets-store-csi-driver/charts"
  chart      = "secrets-store-csi-driver"
  namespace  = "kube-system"
  version    = "1.5.1"

  # (optional) Sync secrets to a Kubernetes Secret (if use ENV variables)
  set {
    name  = "syncSecret.enabled"
    value = true
  }

  # (optional) Enable secret rotation
  set {
    name  = "enableSecretRotation"
    value = true
  }

  depends_on = [aws_eks_node_group.eks_main]
}

resource "helm_release" "secrets_store_csi_driver_provider_aws" {
  name = "secrets-store-csi-driver-provider-aws"

  repository = "https://aws.github.io/secrets-store-csi-driver-provider-aws"
  chart      = "secrets-store-csi-driver-provider-aws"
  namespace  = "kube-system"
  version    = "1.0.1"

  depends_on = [helm_release.secrets_store_csi_driver]
}


