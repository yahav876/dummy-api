module "ecr_rw_role" {
  source  = "cloudposse/iam-role/aws"
  version = "0.21.0"

  enabled            = true
  namespace          = var.namespace
  stage              = var.stage
  name               = var.name
  principals         = var.principals
  policy_documents   = var.policy_documents
  policy_description = var.policy_description
  role_description   = var.role_description
  tags               = var.tags
}

