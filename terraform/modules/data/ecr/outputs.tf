output "repository_arn" {
    value = module.ecr.repository_arn
    depends_on = [
      module.ecr
    ]
  }