module "vpc" {
  source = "./modules/vpc"

  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones   = var.availability_zones
}

module "eks" {
  source = "./modules/eks"

  cluster_name       = "eks-cluster"
  eks_version        = "1.31"
  private_subnet_ids = module.vpc.private_subnet_ids

  node_group_name = "eks-node-group"
  instance_type   = "t3.medium"
  desired_size    = 2
  min_size        = 1
  max_size        = 2
}