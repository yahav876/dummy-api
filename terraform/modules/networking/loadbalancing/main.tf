module "nlb" {
  source = "terraform-aws-modules/alb/aws"
  version = "9.16.0"

  name    = var.nlb.name
  vpc_id  = var.nlb.vpc_id
  subnets = var.nlb.subnets

  load_balancer_type = "network"
  internal            = var.nlb.internal
  enable_cross_zone_load_balancing = var.nlb.enable_cross_zone_load_balancing
  idle_timeout        = var.nlb.idle_timeout

  listeners = {
    http = {
      port     = var.nlb.port
      protocol = var.nlb.listener_protocol
      forward = {
        target_group_key = "main"
      }
    }
  }

  target_groups = {
    main = {
      name_prefix = "tg"
      backend_protocol = var.nlb.target_group_protocol
      backend_port     = var.nlb.target_group_port
      target_type      = var.nlb.target_type
      targets = [
        for id in var.nlb.target_ids : {
          target_id = id
          port      = var.nlb.target_group_port
        }
      ]
    }
  }

  tags = var.nlb.tags
}
