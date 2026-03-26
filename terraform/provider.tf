terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>6.14.0"
    }
  }

  backend "s3" {
    bucket       = "eks-deployment-tfstate"
    key          = "terraform.tfstate"
    region       = "ca-central-1"
    use_lockfile = true
  }
}

provider "aws" {
  region = "ca-central-1"
}

provider "helm" {
  kubernetes = {
    host        = module.eks.eks-cluster-endpoint
    config_path = "~/.kube/config"
  }
}