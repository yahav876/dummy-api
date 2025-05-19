provider "aws" {
  region = var.vpc.region
}

module "vpc" {
  source = "../../modules/networking/vpc"

  vpc = var.vpc
}

module "eks" {
  source = "../../modules/compute/eks"

  eks = merge(
    var.eks,
    {
      vpc_id     = module.vpc.vpc_id
      subnet_ids = module.vpc.subnets_id_private
    }
  )
}

module "ecr" {
  source = "../../modules/data/ecr"
  ecr    = var.ecr
}

