data "aws_caller_identity" "current" {}

resource "aws_iam_role" "eks_admin" {
  name = "${local.eks_cluster_name}-${local.env}-cluster-admin-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          "AWS" = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "eks_admin_policy" {
  name = "AmazonEKSClusterAdminPolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "eks:*"
        ],
        Resource = ["*"]
      },
      {
        Effect = "Allow"
        Action = [
          "iam:PassRole"
        ],
        Condition = {
          StringEquals = {
            "iam:PassedToService" = "eks.amazonaws.com"
          }
        },
        Resource = ["*"]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "eks_admin_policy_attachment" {
  role       = aws_iam_role.eks_admin.name
  policy_arn = aws_iam_policy.eks_admin_policy.arn
}

resource "aws_iam_user" "eks_cluster_admin" {
  name = "eks-cluster-admin"
}

resource "aws_iam_policy" "eks_cluster_admin_assume_role_policy" {
  name = "AmazonEKSAssumeClusterAdminRolePolicy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "sts:AssumeRole"
        ],
        Resource = [aws_iam_role.eks_admin.arn]
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "eks_cluster_admin_assume_role_policy_attachment" {
  policy_arn = aws_iam_policy.eks_cluster_admin_assume_role_policy.arn
  user       = aws_iam_user.eks_cluster_admin.name
}

# It's a best practice to use IAM role instead of IAM user due to role's temporary credentials
resource "aws_eks_access_entry" "eks_cluster_admin_access_entry" {
  cluster_name      = aws_eks_cluster.eks.name
  principal_arn     = aws_iam_role.eks_admin.arn
  kubernetes_groups = ["cluster-admins"]
}
