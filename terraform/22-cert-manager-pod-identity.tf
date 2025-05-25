data "aws_iam_policy_document" "cert-manager" {
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

resource "aws_iam_role" "cert-manager" {
  name = "${local.eks_cluster_name}-${local.env}-cert-manager-iam-role"

  assume_role_policy = data.aws_iam_policy_document.cert-manager.json

  tags = local.common_tags
}

resource "aws_iam_policy" "cert-manager" {
  name = "AmazonEKSCertManagerDNS01ChallengePolicy"

  policy = file("${path.module}/iam/AmazonEKSCertManagerDNS01ChallengePolicy.json")
}

resource "aws_iam_role_policy_attachment" "cert-manager" {
  role       = aws_iam_role.cert-manager.name
  policy_arn = aws_iam_policy.cert-manager.arn
}

resource "aws_eks_pod_identity_association" "cert-manager" {
  cluster_name    = aws_eks_cluster.eks.name
  namespace       = "cert-manager"
  service_account = "cert-manager"
  role_arn        = aws_iam_role.cert-manager.arn
}
