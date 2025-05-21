variable "general_config" {
  description = "General configuration"
  type = object({
    region = optional(string)
  })
  default = {}
}

variable "namespace" {
  type = string
}
variable "stage" {
  type = string
}
variable "name" {
  type = string
}
variable "principals" {
  type = map(list(string))
}
variable "policy_documents" {
  type = list(string)
}
variable "policy_description" {
  type    = string
  default = null
}
variable "role_description" {
  type    = string
  default = null
}
variable "tags" {
  type    = map(string)
  default = {}
}

