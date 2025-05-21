module "ecr" {
  source  = "terraform-aws-modules/ecr/aws"
  version = "1.6.0"

  repository_name                    = var.repository_name
  # repository_read_write_access_arns = var.repository_read_write_access_arns
  repository_lifecycle_policy       = jsonencode(var.repository_lifecycle_policy)
}
