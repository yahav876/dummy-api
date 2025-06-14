general_config = {
  region = "us-east-1"
  default_tags = {
    ManagedBy   = "Terraform"
    Environment = "prod"
    Project     = "bigdata-pipeline"
  }
}

vpc = {

  vpc_name = "dummpy-api"
  vpc_cidr = "172.30.0.0/16"
  region   = "us-east-1"
  vpc_azs  = ["us-east-1a", "us-east-1b", "us-east-1c"]


  private_subnet_cidr = ["172.30.0.0/24", "172.30.16.0/24", "172.30.32.0/24"]
  public_subnet_cidr  = ["172.30.48.0/24", "172.30.64.0/24", "172.30.80.0/24"]

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

  vpc_id     = ""
  subnet_ids = []

}

eks_addon_versions = {
  coredns            = "v1.11.3-eksbuild.1"
  kube_proxy         = "v1.31.2-eksbuild.3"
  vpc_cni            = "v1.19.0-eksbuild.1"
  aws_ebs_csi_driver = "v1.43.0-eksbuild.1"
}


ecr = {
  repository_name = "private-example"

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
  engine_version  = "17.5"
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

  family               = "postgres17"
  major_engine_version = "17"
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
      description = "psql-rds"
      cidr_blocks = ""
    },
    {
      from_port   = 30080
      to_port     = 30080
      protocol    = "tcp"
      description = "psql-nodeport"
      cidr_blocks = "172.30.0.0/16"
    },
  ]

}



iam = {
  namespace          = "example"
  stage              = "dev"
  name               = "ecr-rw-role"

  principals = {
    Service = ["ec2.amazonaws.com"]
  }

  policy_description = "Allows read/write access to specific ECR repo"
  role_description   = "Role used by EC2 for ECR push/pull"

  policy_documents = [] 

  tags = {
    Project     = "bigdata-pipeline"
    Environment = "dev"
  }
}


ecr_policy_config = {
  region          = "us-east-1"
  repository_name = "my-ecr-repo"
}


nlb = {
  internal                                = false
  tcp_enabled                             = true
  access_logs_enabled                     = false
  nlb_access_logs_s3_bucket_force_destroy = false
  nlb_access_logs_s3_bucket_force_destroy_enabled = false
  cross_zone_load_balancing_enabled       = true
  idle_timeout                            = 60
  ip_address_type                         = "ipv4"
  deletion_protection_enabled             = false
  deregistration_delay                    = 300
  health_check_path                       = "/"
  health_check_timeout                    = 5
  health_check_threshold                  = 3
  health_check_unhealthy_threshold        = 3
  health_check_interval                   = 30
  target_group_port                       = 30080
  target_group_target_type                = "instance"
}
