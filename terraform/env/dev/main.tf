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



# module "eks" {
#   source = "../../modules/compute/eks"

#   eks = {
#     cluster_name    = var.eks.cluster_name
#     cluster_version = var.eks.cluster_version

#     cluster_endpoint_public_access           = var.eks.cluster_endpoint_public_access
#     enable_cluster_creator_admin_permissions = var.eks.enable_cluster_creator_admin_permissions

#     cluster_compute_config = var.eks.cluster_compute_config

#     vpc_id     = module.vpc.vpc_id
#     subnet_ids = module.vpc.private_subnets

#     tags = var.eks.tags
#   }
# }
