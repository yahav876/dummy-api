variable "general_config" {
  description = "General configuration"
  type = object({
    region = optional(string)
  })
  default = {}
}

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


variable "policy_config" {
  description = "Configuration for policy module"
  type = object({
    region           = optional(string)
    repository_name  = optional(string)
  })
}
