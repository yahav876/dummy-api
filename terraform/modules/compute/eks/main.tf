module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.36.0"

  cluster_name    = var.cluster_name
  cluster_version = var.cluster_version

  cluster_endpoint_public_access           = var.cluster_endpoint_public_access
  enable_cluster_creator_admin_permissions = var.enable_cluster_creator_admin_permissions

  vpc_id     = var.vpc_id
  subnet_ids = var.subnet_ids

  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  cluster_addons = {
    coredns = {
      addon_version     = var.eks_addon_versions.coredns
      resolve_conflicts = "OVERWRITE"
    }

    kube-proxy = {
      addon_version     = var.eks_addon_versions.kube_proxy
      resolve_conflicts = "OVERWRITE"
    }

    vpc-cni = {
      addon_version     = var.eks_addon_versions.vpc_cni
      resolve_conflicts = "OVERWRITE"
    }

    aws-ebs-csi-driver = {
      addon_version     = var.eks_addon_versions.aws_ebs_csi_driver
      resolve_conflicts = "OVERWRITE"
    }
  }

}
