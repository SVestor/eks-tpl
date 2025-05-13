resource "aws_iam_user" "dev_user_eks" {
  name = "dev-user-eks"
}

resource "aws_iam_policy" "dev_user_eks_policy" {
  name = "AmazonEKSDevUserPolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:DescribeCluster",
          "eks:ListClusters",
        ]
        Resource = [aws_eks_cluster.eks.arn]
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "dev_user_eks_policy_attachment" {
  policy_arn = aws_iam_policy.dev_user_eks_policy.arn
  user       = aws_iam_user.dev_user_eks.name
}

resource "aws_eks_access_entry" "dev_user_eks_access_entry" {
  cluster_name      = aws_eks_cluster.eks.name
  principal_arn     = aws_iam_user.dev_user_eks.arn
  kubernetes_groups = ["viewers"]
}
