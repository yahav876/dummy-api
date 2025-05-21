variable "general_config" {
  description = "General configuration"
  type = object({
    region       = string
    default_tags = map(string)
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

    vpc_id     = string
    subnet_ids = list(string)

  })
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



variable "ecr" {
  description = "ECR config to pass to ECR module"
  type = object({
    repository_name                   = string
    # repository_read_write_access_arns = list(string)
    repository_lifecycle_policy       = any

  })
}


variable "db" {
  description = "RDS PostgreSQL config for dev"
  type = object({
    identifier                             = string
    engine_version                         = string
    instance_class                         = string
    allocated_storage                      = number
    db_name                                = string
    username                               = string
    port                                   = number
    iam_database_authentication_enabled    = bool
    vpc_security_group_ids                 = list(string)
    maintenance_window                     = string
    backup_window                          = string
    monitoring_interval                    = number
    monitoring_role_name                   = string
    create_monitoring_role                 = bool
    tags                                   = map(string)
    create_db_subnet_group                 = bool
    subnet_ids                             = list(string)
    family                                 = string
    major_engine_version                   = string
    deletion_protection                    = bool
    parameters                             = list(map(string))
  })
}


variable "sg" {
  description = "Security group configuration object"
  type = object({
    name                      = string
    description               = string
    vpc_id                    = string
    ingress_with_cidr_blocks = list(map(string))
    tags                      = optional(map(string), {})
  })
}


variable "iam" {
  description = "IAM role configuration"
  type = object({
    namespace          = string
    stage              = string
    name               = string
    principals         = map(list(string))
    policy_description = optional(string)
    role_description   = optional(string)
    policy_documents   = list(string)
    tags               = optional(map(string), {})
  })
}

variable "ecr_policy_config" {
  description = "ECR policy config passed to the policy module"
  type = object({
    region          = string
    repository_name = string
  })
}

variable "nlb" {
  description = "Configuration object for NLB"
  type = object({
    internal                                = bool
    tcp_enabled                             = bool
    access_logs_enabled                     = bool
    nlb_access_logs_s3_bucket_force_destroy = bool
    nlb_access_logs_s3_bucket_force_destroy_enabled = bool
    cross_zone_load_balancing_enabled       = bool
    idle_timeout                            = number
    ip_address_type                         = string
    deletion_protection_enabled             = bool
    deregistration_delay                    = number
    health_check_path                       = string
    health_check_timeout                    = number
    health_check_threshold                  = number
    health_check_unhealthy_threshold        = number
    health_check_interval                   = number
    target_group_port                       = number
    target_group_target_type                = string
  })
}
