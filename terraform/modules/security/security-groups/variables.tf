variable "sg" {
  description = "Security group configuration"
  type = object({
    name                      = string
    description               = string
    vpc_id                    = string
    ingress_with_cidr_blocks = list(map(string))
    tags                      = optional(map(string), {})
  })
}
