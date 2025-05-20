variable "iam" {
  description = "IAM role configuration"
  type = object({
    namespace          = string
    stage              = string
    name               = string
    principals         = map(list(string))
    policy_description = optional(string)
    role_description   = optional(string)
    policy_documents   = list(string)
    tags               = optional(map(string), {})
  })
}
