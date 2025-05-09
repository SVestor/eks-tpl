resource "aws_subnet" "private" {
  for_each = local.private_subnets

  cidr_block        = each.value.ip
  availability_zone = each.value.az

  vpc_id = aws_vpc.eks_vpc.id

  tags = merge(each.value.tags, local.common_tags)
}

resource "aws_subnet" "public" {
  for_each = local.public_subnets

  cidr_block        = each.value.ip
  availability_zone = each.value.az
  map_public_ip_on_launch = true

  vpc_id = aws_vpc.eks_vpc.id

  tags = merge(each.value.tags, local.common_tags)
}

