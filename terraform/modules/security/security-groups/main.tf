# module "security_group" {
#   source  = "terraform-aws-modules/security-group/aws"
#   version = "5.3.0" 

#   name                      = var.sg.name
#   description               = var.sg.description
#   vpc_id                    = var.sg.vpc_id
#   ingress_with_cidr_blocks  = var.sg.ingress_with_cidr_blocks
#   tags                      = var.sg.tags
# }

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "5.3.0"

  name                      = var.name
  description               = var.description
  vpc_id                    = var.vpc_id
  ingress_with_cidr_blocks = var.ingress_with_cidr_blocks
  tags                      = var.tags
}
