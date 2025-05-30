# This is older method, required to use OIDC and IRSA
# New method is to use Pod Identity Association and eks_addon
# Also we can use helm chart to install efs-csi-driver instead of using eks_addon

data "tls_certificate" "eks" {
  url = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.eks.identity[0].oidc[0].issuer
}

data "aws_iam_policy_document" "efs_csi_driver_irsa" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]
    effect  = "Allow"

    condition {
      test     = "StringEquals"
      variable = "${replace(aws_iam_openid_connect_provider.eks.url, "https://", "")}:sub"
      values   = ["system:serviceaccount:kube-system:efs-csi-controller-sa"]
    }

    principals {
      identifiers = [aws_iam_openid_connect_provider.eks.arn]
      type        = "Federated"
    }
  }
}

resource "aws_iam_role" "efs_csi_driver_irsa" {
  name               = "${local.eks_cluster_name}-${local.env}-efs-csi-driver-irsa-iam-role"
  assume_role_policy = data.aws_iam_policy_document.efs_csi_driver_irsa.json

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "efs_csi_driver_irsa" {
  role       = aws_iam_role.efs_csi_driver_irsa.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
}

resource "helm_release" "efs_csi_driver" {
  name = "aws-efs-csi-driver"

  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
  chart      = "aws-efs-csi-driver"
  namespace  = "kube-system"
  version    = "3.1.9"

  set {
    name  = "controller.serviceAccount.name"
    value = "efs-csi-controller-sa"
  }

  set {
    name  = "controller.serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.efs_csi_driver_irsa.arn
  }

  depends_on = [
    aws_efs_mount_target.eks_efs_private
  ]
}
