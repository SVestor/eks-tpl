resource "aws_iam_role" "eks_nodes" {
  name = "${local.eks_cluster_name}-${local.env}-cluster-nodes-create-iam-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags = local.common_tags
}

resource "aws_iam_role_policy_attachment" "eks_worker_nodes_policies" {
  for_each   = toset(local.nodes_policies)
  role       = aws_iam_role.eks_nodes.name
  policy_arn = "arn:aws:iam::aws:policy/${each.value}"
}

resource "aws_eks_node_group" "eks_main" {
  cluster_name    = aws_eks_cluster.eks.name
  version         = local.eks_cluster_version
  node_group_name = "main-ng"
  node_role_arn   = aws_iam_role.eks_nodes.arn

  capacity_type  = "ON_DEMAND" # or SPOT
  instance_types = ["t3.medium"]

  scaling_config {
    min_size     = 0
    max_size     = 5
    desired_size = 1
  }

  update_config {
    max_unavailable = 1
  }

  subnet_ids = [for subnet in aws_subnet.private : subnet.id]

  labels = {
    role = "main-ng"
    # "kubernetes.io/arch" = "amd64"
    # "kubernetes.io/os"   = "linux"
  }

  taint {
    key    = "main-ng"
    value  = "dedicated"
    effect = "PREFER_NO_SCHEDULE"
  }

  # Optional: Allow external changes without Terraform plan difference

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }

  tags = local.common_tags

  depends_on = [aws_iam_role_policy_attachment.eks_worker_nodes_policies] # To avoid dependency issues

}

