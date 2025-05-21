variable "policy_config" {
  description = "Configuration for ECR policy"
  type = object({
    region          = string
    repository_name = string
  })
}
