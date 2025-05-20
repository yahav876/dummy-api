module "ecr_rw_role" {
  source  = "cloudposse/iam-role/aws"
  version = "0.21.0"

  enabled            = true
  namespace          = var.iam.namespace
  stage              = var.iam.stage
  name               = var.iam.name
  principals         = var.iam.principals
  policy_documents   = var.iam.policy_documents
  policy_description = var.iam.policy_description
  role_description   = var.iam.role_description
  tags               = var.iam.tags
}

module "ecr_rw_policy" {
  source           = "./policies"
  region           = var.ecr_policy_config.region
  repository_name  = var.ecr_policy_config.repository_name
}
