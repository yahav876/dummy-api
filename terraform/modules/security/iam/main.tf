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
