locals {
  env                 = "dev"
  region              = "us-east-1"
  terraform           = "true"
  eks_cluster_name    = "core-eks"
  eks_cluster_version = "1.33"
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
        "kubernetes.io/cluster/${local.eks_cluster_name}-${local.env}" = "owned"
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
        "kubernetes.io/cluster/${local.eks_cluster_name}-${local.env}" = "owned"
      }
    }
  }
}

locals {
  nodes_policies = [
    "AmazonEKSWorkerNodePolicy",
    "AmazonEKS_CNI_Policy",
    "AmazonEC2ContainerRegistryReadOnly"
  ]
}

locals {
  flask_app_hostname         = "flask-app.${lookup(var.subdomain, local.env)}.${var.dns_zone_name}"
  flask_app_ingress_alb_name = "k8s-flask-app-alb-${local.eks_cluster_name}-${local.env}"
}



