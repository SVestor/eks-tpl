resource "aws_iam_group" "developers_eks" {
  name = "developers-eks"
  path = "/users/"  # optional
}

resource "aws_iam_user" "dev_user2_eks" {
  name = "dev-user2-eks"
}

resource "aws_iam_user" "dev_user3_eks" {
  name = "dev-user3-eks"
}

resource "aws_iam_user_group_membership" "dev_user2_eks" {
  user = aws_iam_user.dev_user2_eks.name

  groups = [aws_iam_group.developers_eks.name]
}

resource "aws_iam_user_group_membership" "dev_user3_eks" {
  user = aws_iam_user.dev_user3_eks.name

  groups = [aws_iam_group.developers_eks.name]
}

resource "aws_iam_group_policy" "developers_eks_policy" {
  name = "AmazonEKSDevelopersGroupPolicy"

  group = aws_iam_group.developers_eks.name

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

resource "aws_eks_access_entry" "dev_user2_eks_access_entry" {
  cluster_name      = aws_eks_cluster.eks.name
  principal_arn     = aws_iam_user.dev_user2_eks.arn
  kubernetes_groups = ["viewers"]
}

resource "aws_eks_access_entry" "dev_user3_eks_access_entry" {
  cluster_name      = aws_eks_cluster.eks.name
  principal_arn     = aws_iam_user.dev_user3_eks.arn
  kubernetes_groups = ["viewers"]
}

# aws_iam_group_membership will conflict with itself if used more than once with the same group

# resource "aws_iam_group_membership" "developers_eks" {
#   name = "developers-eks"

#   users = [
#     aws_iam_user.dev_user2_eks.name,
#     aws_iam_user.dev_user3_eks.name,
#   ]

#   group = aws_iam_group.developers_eks.name
# }
