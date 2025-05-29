data "aws_iam_policy_document" "efs_csi_driver" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["pods.eks.amazonaws.com"]
    }

    actions = [
      "sts:AssumeRole",
      "sts:TagSession"
    ]
  }
}

resource "aws_iam_role" "efs_csi_driver" {
  name = "${local.eks_cluster_name}-${local.env}-efs-csi-driver-iam-role"

  assume_role_policy = data.aws_iam_policy_document.efs_csi_driver.json

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "efs_csi_driver" {
  role       = aws_iam_role.efs_csi_driver.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
}

resource "aws_eks_pod_identity_association" "efs_csi_driver" {
  cluster_name    = aws_eks_cluster.eks.name
  namespace       = "kube-system"
  service_account = "efs-csi-controller-sa"
  role_arn        = aws_iam_role.efs_csi_driver.arn
}

resource "aws_eks_addon" "efs_csi_driver" {
  cluster_name             = aws_eks_cluster.eks.name
  addon_name               = "aws-efs-csi-driver"
  addon_version            = "v2.1.8-eksbuild.1"
  service_account_role_arn = aws_iam_role.efs_csi_driver.arn

  depends_on = [aws_efs_mount_target.eks_efs_private]
}
