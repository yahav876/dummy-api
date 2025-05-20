variable "db" {
  description = "PostgreSQL RDS configuration"
  type = object({
    identifier                             = string
    engine_version                         = string
    instance_class                         = string
    allocated_storage                      = number
    db_name                                = string
    username                               = string
    port                                   = number
    iam_database_authentication_enabled    = bool
    vpc_security_group_ids                 = list(string)
    maintenance_window                     = string
    backup_window                          = string
    monitoring_interval                    = number
    monitoring_role_name                   = string
    create_monitoring_role                 = bool
    tags                                   = map(string)
    create_db_subnet_group                 = bool
    subnet_ids                             = list(string)
    family                                 = string
    major_engine_version                   = string
    deletion_protection                    = bool
    parameters                             = list(map(string))
  })
}
