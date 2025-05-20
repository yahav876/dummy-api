output "ecr_role_arn" {
    value = module.ecr_rw_role.arn
    depends_on = [
      module.ecr_rw_role
    ]
  }

