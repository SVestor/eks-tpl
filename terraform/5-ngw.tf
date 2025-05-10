resource "aws_eip" "ngw" {
  domain = "vpc"

  tags = merge(
    { Name = "${local.eks_cluster_name}-${local.env}-ngw" },
    local.common_tags
  )
}

resource "aws_nat_gateway" "ngw" {
  allocation_id = aws_eip.ngw.id
  subnet_id     = aws_subnet.public[keys(aws_subnet.public)[0]].id

  tags = merge(
    { Name = "${local.eks_cluster_name}-${local.env}-ngw-${aws_subnet.public[keys(aws_subnet.public)[0]].availability_zone}" },
    local.common_tags
  )

  depends_on = [aws_internet_gateway.igw] # to ensure that the igw is created before the ngw
}

