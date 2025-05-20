provider "aws" {
  region = var.vpc.region
}

module "vpc" {
  source = "../../modules/networking/vpc"

  vpc = var.vpc
}

module "eks" {
  source = "../../modules/compute/eks"

  eks = merge(
    var.eks,
    {
      vpc_id     = module.vpc.vpc_id
      subnet_ids = module.vpc.subnets_id_private
    }
  )
}

module "ecr" {
  source = "../../modules/data/ecr"

    ecr = merge(
    var.ecr,
    {
      repository_read_write_access_arns = [module.ecr_rw_role.ecr_role_arn]

    }
  )

}



module "db" {
  source = "../../modules/data/rds"

    db = merge(
    var.db,
    {
      subnet_ids = module.vpc.subnets_id_private
      vpc_security_group_ids = module.security_group.security_group_id

    }
  )
}


module "security_group" {
  source = "../../modules/security/security-groups"

  sg = merge(
    var.sg,
    {
      vpc_id = module.vpc.vpc_id
      ingress_with_cidr_blocks = [
        {
          from_port   = 5432
          to_port     = 5432
          protocol    = "tcp"
          description = "Allow PostgreSQL from internal VPC"
          cidr_blocks = module.vpc.vpc_cidr
        }
      ]
    }
  )
}

module "ecr_rw_role" {
  source = "../../modules/security/iam"

      iam = merge(
    var.iam,
    {
      policy_documents = [data.aws_iam_policy_document.ecr_read_write.json]

    }
  )
}