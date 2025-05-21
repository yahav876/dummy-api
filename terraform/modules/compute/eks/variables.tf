variable "cluster_name" {
  type = string
}
variable "cluster_version" {
  type = string
}
variable "cluster_endpoint_public_access" {
  type = bool
}
variable "enable_cluster_creator_admin_permissions" {
  type = bool
}

variable "eks_addon_versions" {
  description = "Map of fixed versions for EKS core add-ons"
  type = object({
    coredns              = string
    kube_proxy           = string
    vpc_cni              = string
    aws_ebs_csi_driver   = string
  })
}


variable "vpc_id" {
  type = string
}
variable "subnet_ids" {
  type = list(string)
}


