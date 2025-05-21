terraform {
  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.6"
    }

    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.17"
    }
  }
}

provider "aws" {
  region  = local.region
  profile = "cloud-user"
}
