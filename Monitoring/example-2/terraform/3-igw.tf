resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.eks_vpc.id

  tags = merge(
    { Name = "${local.eks_cluster_name}-${local.env}-igw" },
    local.common_tags
  )
}
