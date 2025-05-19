general_config = {
  region = "us-east-1"
}

vpc = {

  vpc_name = "example"
  vpc_cidr = "172.25.0.0/16"
  region   = "us-west-2"
  vpc_azs  = ["us-west-2a", "us-west-2b", "us-west-2c"]


  private_subnet_cidr = ["172.25.0.0/20", "172.25.16.0/20", "172.25.32.0/20"]
  public_subnet_cidr  = ["172.25.48.0/20", "172.25.64.0/20", "172.25.80.0/20"]

  enable_nat_gateway     = true
  one_nat_gateway_per_az = true

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

}


eks = {
  cluster_name    = "example-eks"
  cluster_version = "1.31"

  cluster_endpoint_public_access           = true
  enable_cluster_creator_admin_permissions = true

  cluster_compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  # Temporary placeholders — these will be overridden by outputs from VPC module
  vpc_id     = ""
  subnet_ids = []

}


ecr = {
  repository_name = "private-example"

  repository_read_write_access_arns = [
    "arn:aws:iam::012345678901:role/terraform"
  ]
  repository_lifecycle_policy = {
    rules = [
      {
        rulePriority = 1
        description  = "Keep last 30 images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["v"]
          countType     = "imageCountMoreThan"
          countNumber   = 30
        }
        action = {
          type = "expire"
        }
      }
    ]
  }

}

