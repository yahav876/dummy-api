variable "general_config" {
  description = "General configuration"
  type = object({
    region       = string
  })
}

variable "vpc" {
  description = "VPC configuration block"
  type = object({
    vpc_name        = string
    vpc_cidr        = string
    region          = string
    vpc_azs         = list(string)

    private_subnet_cidr  = list(string)
    public_subnet_cidr = list(string)

    enable_nat_gateway     = bool

    one_nat_gateway_per_az = bool
    private_subnet_tags = map(string)
    public_subnet_tags  = map(string)

  })
}


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

  })
}


variable "ecr" {
  description = "ECR config to pass to ECR module"
  type = object({
    repository_name                   = string
    repository_read_write_access_arns = list(string)
    repository_lifecycle_policy       = any

  })
}