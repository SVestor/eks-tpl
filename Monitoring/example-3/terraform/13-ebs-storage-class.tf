# Optional: This section is not required as the Helm provider was initialized earlier.
# Shown here to keep the configuration standalone

data "aws_eks_cluster" "eks_k8s" {
  name = aws_eks_cluster.eks.name
}

data "aws_eks_cluster_auth" "eks_k8s" {
  name = aws_eks_cluster.eks.name
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks_k8s.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_k8s.certificate_authority[0].data)
  token                  = data.aws_eks_cluster_auth.eks_k8s.token
}

resource "kubernetes_storage_class_v1" "gp3_monitoring" {
  metadata {
    name = "gp3-monitoring"
  }

  storage_provisioner    = "ebs.csi.aws.com"
  reclaim_policy         = "Delete" # Retain | Delete
  volume_binding_mode    = "WaitForFirstConsumer"
  allow_volume_expansion = true

  parameters = {
    type      = "gp3"
    fsType    = "ext4"
    encrypted = "true"
  }

  depends_on = [aws_eks_addon.ebs_csi_driver]
}
