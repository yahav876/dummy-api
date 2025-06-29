provider "aws" {
  region = var.vpc.region

  default_tags {
      tags = var.general_config.default_tags
  }
}

module "vpc" {
  source = "../../modules/networking/vpc"

  vpc_name               = var.vpc.vpc_name
  vpc_cidr               = var.vpc.vpc_cidr
  region                 = var.vpc.region
  vpc_azs                = var.vpc.vpc_azs
  private_subnet_cidr    = var.vpc.private_subnet_cidr
  public_subnet_cidr     = var.vpc.public_subnet_cidr
  enable_nat_gateway     = var.vpc.enable_nat_gateway
  one_nat_gateway_per_az = var.vpc.one_nat_gateway_per_az
  private_subnet_tags  = var.vpc.private_subnet_tags
  public_subnet_tags   = var.vpc.public_subnet_tags
}


module "eks" {
  source = "../../modules/compute/eks"

  cluster_name                          = var.eks.cluster_name
  cluster_version                       = var.eks.cluster_version
  cluster_endpoint_public_access        = var.eks.cluster_endpoint_public_access
  enable_cluster_creator_admin_permissions = var.eks.enable_cluster_creator_admin_permissions

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.subnets_id_private

  eks_addon_versions = var.eks_addon_versions
}


module "ecr" {
  source = "../../modules/data/ecr"

  repository_name                    = var.ecr.repository_name
  repository_lifecycle_policy       = var.ecr.repository_lifecycle_policy
}


module "db" {
  source = "../../modules/data/rds"

  identifier                          = var.db.identifier
  engine_version                      = var.db.engine_version
  instance_class                      = var.db.instance_class
  allocated_storage                   = var.db.allocated_storage
  db_name                             = var.db.db_name
  username                            = var.db.username
  port                                = var.db.port
  iam_database_authentication_enabled = var.db.iam_database_authentication_enabled

  vpc_security_group_ids = [module.security_group.security_group_id]
  maintenance_window     = var.db.maintenance_window
  backup_window          = var.db.backup_window

  monitoring_interval    = var.db.monitoring_interval
  monitoring_role_name   = var.db.monitoring_role_name
  create_monitoring_role = var.db.create_monitoring_role

  tags = var.db.tags

  create_db_subnet_group = var.db.create_db_subnet_group
  subnet_ids             = module.vpc.subnets_id_private

  family               = var.db.family
  major_engine_version = var.db.major_engine_version

  deletion_protection = var.db.deletion_protection
  parameters          = var.db.parameters


}


module "security_group" {
  source = "../../modules/security/security-groups"

  name                      = var.sg.name
  description               = var.sg.description
  vpc_id                    = module.vpc.vpc_id
  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "Allow PostgreSQL from internal VPC"
      cidr_blocks = module.vpc.vpc_cidr
    }
  ]
  tags = var.sg.tags
}

module "ecr_rw_role" {
  source = "../../modules/security/iam"

  namespace          = var.iam.namespace
  stage              = var.iam.stage
  name               = var.iam.name
  principals         = var.iam.principals
  policy_documents   = [data.aws_iam_policy_document.ecr_read_write.json]
  policy_description = var.iam.policy_description
  role_description   = var.iam.role_description
  tags               = var.iam.tags
}

module "airflow_nlb" {
  source = "../../modules/networking/loadbalancing"

  vpc_id                                         = module.vpc.vpc_id
  subnet_ids                                     = module.vpc.subnets_id_public

  internal                                       = var.nlb.internal
  tcp_enabled                                    = var.nlb.tcp_enabled
  access_logs_enabled                            = var.nlb.access_logs_enabled
  nlb_access_logs_s3_bucket_force_destroy        = var.nlb.nlb_access_logs_s3_bucket_force_destroy
  nlb_access_logs_s3_bucket_force_destroy_enabled = var.nlb.nlb_access_logs_s3_bucket_force_destroy_enabled
  cross_zone_load_balancing_enabled              = var.nlb.cross_zone_load_balancing_enabled
  idle_timeout                                   = var.nlb.idle_timeout
  ip_address_type                                = var.nlb.ip_address_type
  deletion_protection_enabled                    = var.nlb.deletion_protection_enabled
  deregistration_delay                           = var.nlb.deregistration_delay
  health_check_path                              = var.nlb.health_check_path
  health_check_timeout                           = var.nlb.health_check_timeout
  health_check_unhealthy_threshold               = var.nlb.health_check_unhealthy_threshold
  health_check_interval                          = var.nlb.health_check_interval
  target_group_port                              = var.nlb.target_group_port
  target_group_target_type                       = var.nlb.target_group_target_type

}

locals {
  eks_asg_map = {
    example = module.eks.eks_managed_node_groups_autoscaling_group_names[0]
  }
}

resource "aws_autoscaling_attachment" "nlb_asg_attachments" {
  for_each = local.eks_asg_map

  autoscaling_group_name = each.value
  lb_target_group_arn    = module.airflow_nlb.target_group_arn
}
