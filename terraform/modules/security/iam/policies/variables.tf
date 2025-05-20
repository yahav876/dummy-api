
variable "policy_config" {
  description = "Configuration for policy module"
  type = object({
    region           = optional(string)
    repository_name  = optional(string)
  })
}
