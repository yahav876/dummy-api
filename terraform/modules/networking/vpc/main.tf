module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "5.21.0"


  name        = var.vpc.vpc_name
  cidr        = var.vpc.vpc_cidr
  azs             = var.vpc_azs

  private_subnets = var.vpc.private_subnet_cidr
  public_subnets  = var.vpc.public_subnet_cidr

  enable_nat_gateway   = var.vpc.enable_nat_gateway

  private_subnet_tags = var.vpc.private_subnet_tags
  public_subnet_tags  = var.vpc.public_subnet_tags

}

