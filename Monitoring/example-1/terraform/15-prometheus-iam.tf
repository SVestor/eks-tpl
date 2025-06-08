data "aws_iam_policy_document" "prometheus" {
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

resource "aws_iam_role" "prometheus" {
  name = "${local.eks_cluster_name}-${local.env}-prometheus-iam-role"

  assume_role_policy = data.aws_iam_policy_document.prometheus.json

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "prometheus" {
  role       = aws_iam_role.prometheus.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
}

resource "aws_eks_pod_identity_association" "prometheus" {
  cluster_name    = aws_eks_cluster.eks.name
  namespace       = "monitoring"
  service_account = "prometheus"
  role_arn        = aws_iam_role.prometheus.arn
}
