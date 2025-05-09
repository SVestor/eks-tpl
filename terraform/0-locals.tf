locals {
  env                 = "dev"
  region              = "us-east-1"
  terraform           = "true"
  eks_cluster_name    = "core-eks"
  eks_cluster_version = "1.31"
}

locals {
  common_tags = {
    Environment = lower(local.env)
    Region      = lower(local.region)
    Terraform   = lower(local.terraform)
  }
}

locals {
  private_subnets = {
    for idx, subnet in var.eks_subnets.private :
    "private-${idx}" => {
      ip = subnet.ip
      az = subnet.az
      tags = {
        Name                                                           = "${local.eks_cluster_name}-${local.env}-private-${idx}-${subnet.az}"
        "kubernetes.io/role/internal-elb"                              = "1"
        "kubernetes.io/cluster/${local.env}-${local.eks_cluster_name}" = "owned"
      }
    }
  }
  public_subnets = {
    for idx, subnet in var.eks_subnets.public :
    "public-${idx}" => {
      ip = subnet.ip
      az = subnet.az
      tags = {
        Name                                                           = "${local.eks_cluster_name}-${local.env}-public-${idx}-${subnet.az}"
        "kubernetes.io/role/elb"                                       = "1"
        "kubernetes.io/cluster/${local.env}-${local.eks_cluster_name}" = "owned"
      }
    }
  }
}



