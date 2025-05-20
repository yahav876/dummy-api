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


db = {
  identifier      = "demodb"
  engine_version  = "15.5"
  instance_class  = "db.t3.medium"
  allocated_storage = 20

  db_name  = "demodb"
  username = "postgres"
  port     = 5432

  iam_database_authentication_enabled = true

  vpc_security_group_ids = []
  subnet_ids             = []
  create_db_subnet_group = true

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  monitoring_interval    = 30
  monitoring_role_name   = "MyRDSMonitoringRole"
  create_monitoring_role = true

  family               = "postgres15"
  major_engine_version = "15"
  deletion_protection  = true

  parameters = [
    {
      name  = "log_min_duration_statement"
      value = "1000"
    },
    {
      name  = "log_statement"
      value = "mod"
    }
  ]

  tags = {
    Owner       = "devops"
    Environment = "dev"
  }
}



sg = {
  name        = "user-service"
  description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = ""



  ingress_with_cidr_blocks = [
    {
      from_port   = 5432
      to_port     = 5432
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = ""
    },

  ]

}




iam = {
  namespace          = "example"
  stage              = "dev"
  name               = "ecr-rw-role"

  principals = {
    AWS = ["arn:aws:iam::123456789012:user/ci"]
  }

  policy_description = "Allows read/write access to specific ECR repo"
  role_description   = "Role used by CI pipeline for ECR push/pull"

  policy_documents = [] 

  tags = {
    Project     = "bigdata-pipeline"
    Environment = "dev"
  }
}