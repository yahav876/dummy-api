module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.36.0"

  cluster_name    = var.eks.cluster_name
  cluster_version = var.eks.cluster_version

  cluster_endpoint_public_access           = var.eks.cluster_endpoint_public_access
  enable_cluster_creator_admin_permissions = var.eks.enable_cluster_creator_admin_permissions

  cluster_compute_config = var.eks.cluster_compute_config

  vpc_id     = var.eks.vpc_id
  subnet_ids = var.eks.subnet_ids

}

# module "eks" {
#   source  = "terraform-aws-modules/eks/aws"
#   version = "20.36.0"

#   cluster_name    = "example"
#   cluster_version = "1.31"

#   # Optional
#   cluster_endpoint_public_access = true

#   # Optional: Adds the current caller identity as an administrator via cluster access entry
#   enable_cluster_creator_admin_permissions = true

#   cluster_compute_config = {
#     enabled    = true
#     node_pools = ["general-purpose"]
#   }

#   vpc_id     = "vpc-1234556abcdef"
#   subnet_ids = ["subnet-abcde012", "subnet-bcde012a", "subnet-fghi345a"]

#   tags = {
#     Environment = "dev"
#     Terraform   = "true"
#   }
# }