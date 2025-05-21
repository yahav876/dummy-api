# variable "sg" {
#   description = "Security group configuration"
#   type = object({
#     name                      = string
#     description               = string
#     vpc_id                    = string
#     ingress_with_cidr_blocks = list(map(string))
#     tags                      = optional(map(string), {})
#   })
# }


variable "name" {
  type = string
}
variable "description" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "ingress_with_cidr_blocks" {
  type = list(map(string))
}
variable "tags" {
  type    = map(string)
  default = {}
}
