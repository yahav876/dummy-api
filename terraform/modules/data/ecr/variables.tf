variable "ecr" {
  description = "ECR configuration object"
  type = object({
    repository_name                   = string
    repository_read_write_access_arns = list(string)
    repository_lifecycle_policy       = any
  })
}
