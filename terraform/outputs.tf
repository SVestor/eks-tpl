output "eks_admin_iam_role_arn" {
  value = aws_iam_role.eks_admin.arn
}

output "eks_endpoint" {
  value = aws_eks_cluster.eks.endpoint
}
