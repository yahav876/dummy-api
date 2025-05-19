variable "eks" {
  description = "EKS cluster configuration"
  type = object({
    cluster_name    = string
    cluster_version = string

    cluster_endpoint_public_access                = bool
    enable_cluster_creator_admin_permissions      = bool

    cluster_compute_config = object({
      enabled    = bool
      node_pools = list(string)
    })

    vpc_id     = string
    subnet_ids = list(string)

    # tags = map(string)
  })
}
