module "nlb" {
    source = "cloudposse/nlb/aws"
    version = "0.18.1"

    vpc_id                                          = var.vpc_id
    subnet_ids                                      = var.subnet_ids
    internal                                        = var.internal
    tcp_enabled                                     = var.tcp_enabled
    access_logs_enabled                             = var.access_logs_enabled
    nlb_access_logs_s3_bucket_force_destroy         = var.nlb_access_logs_s3_bucket_force_destroy
    cross_zone_load_balancing_enabled               = var.cross_zone_load_balancing_enabled
    ip_address_type                                 = var.ip_address_type
    deletion_protection_enabled                     = var.deletion_protection_enabled
    deregistration_delay                            = var.deregistration_delay
    health_check_path                               = var.health_check_path
    health_check_timeout                            = var.health_check_timeout
    health_check_unhealthy_threshold                = var.health_check_unhealthy_threshold
    health_check_interval                           = var.health_check_interval
    target_group_port                               = var.target_group_port
    target_group_target_type                        = var.target_group_target_type

  }