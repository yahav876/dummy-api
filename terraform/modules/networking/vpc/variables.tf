variable "vpc" {
  description = "VPC configuration block"
  type = object({
    vpc_name        = string
    vpc_cidr        = string
    region          = string
    vpc_azs         = list(string)

    private_subnet_cidr  = list(string)
    public_subnet_cidr = list(string)

    enable_nat_gateway     = bool

    one_nat_gateway_per_az = bool
    private_subnet_tags = map(string)
    public_subnet_tags  = map(string)

  })
}


# variable "private_subnet_tags" {
#   type        = map(string)
#   description = "Additional tags for private subnets"
#   default     = {}
# }

# variable "public_subnet_tags" {
#   type        = map(string)
#   description = "Additional tags for public subnets"
#   default     = {}
# }

variable "private_subnet_cidr" {
  type    = list(any)
  default = [""]

}

variable "public_subnet_cidr" {
  type    = list(any)
  default = [""]

}

variable "vpc_azs" {
  type    = list(any)
  default = [""]

}

variable "subnets_id" {
  type    = string
  default = ""
}

variable "vpc_id" {
  type    = string
  default = ""
}
