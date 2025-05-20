output "ecr_role_arn" {
    value = module.ecr_rw_role.arn
    depends_on = [
      module.ecr_rw_role
    ]
  }


output "ecr_policy_document" {
  value = data.aws_iam_policy_document.ecr_read_write.json
}
