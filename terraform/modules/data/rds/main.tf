module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.12.0" 

  identifier                          = var.db.identifier
  engine                              = "postgres"
  engine_version                      = var.db.engine_version
  instance_class                      = var.db.instance_class
  allocated_storage                   = var.db.allocated_storage
  db_name                             = var.db.db_name
  username                            = var.db.username
  port                                = var.db.port
  iam_database_authentication_enabled = var.db.iam_database_authentication_enabled

  vpc_security_group_ids = var.db.vpc_security_group_ids
  maintenance_window     = var.db.maintenance_window
  backup_window          = var.db.backup_window

  monitoring_interval    = var.db.monitoring_interval
  monitoring_role_name   = var.db.monitoring_role_name
  create_monitoring_role = var.db.create_monitoring_role

  tags = var.db.tags

  create_db_subnet_group = var.db.create_db_subnet_group
  subnet_ids             = var.db.subnet_ids

  family               = var.db.family
  major_engine_version = var.db.major_engine_version

  deletion_protection = var.db.deletion_protection
  parameters          = var.db.parameters

  # PostgreSQL does not use DB options like MySQL
  options = []
}
