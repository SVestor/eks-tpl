resource "aws_efs_file_system" "eks_efs" {
  creation_token = "eks-efs-idempotent-token"

  performance_mode = "generalPurpose"
  throughput_mode  = "bursting"
  encrypted        = true

  # Optional: only if you want to transit files to IA (Infrequent Access) after 7 to 90 days
  # For performance_mode = generalPurpose this is the only option
  # For performance_mode = maxIO this option is not available 
  lifecycle_policy {
    transition_to_ia = "AFTER_90_DAYS"
  }

  tags = local.common_tags
}

resource "aws_security_group" "eks_efs" {
  name        = "${local.eks_cluster_name}-${local.env}-efs-sg"
  description = "Security group for EFS access from EKS nodes"
  vpc_id      = aws_vpc.eks_vpc.id

  ingress {
    from_port = 2049
    to_port   = 2049
    protocol  = "tcp"
    security_groups = [
      aws_eks_cluster.eks.vpc_config[0].cluster_security_group_id
    ]
  }

  tags = local.common_tags
}

resource "aws_efs_mount_target" "eks_efs_private" {
  for_each = aws_subnet.private

  file_system_id = aws_efs_file_system.eks_efs.id
  subnet_id      = each.value.id

  security_groups = [
    aws_security_group.eks_efs.id
  ]
}
