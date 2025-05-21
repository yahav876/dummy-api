variable "identifier" {
  type = string
}

variable "engine_version" {
  type = string
}

variable "instance_class" {
  type = string
}

variable "allocated_storage" {
  type = number
}

variable "db_name" {
  type = string
}

variable "username" {
  type = string
}

variable "port" {
  type = number
}

variable "iam_database_authentication_enabled" {
  type = bool
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "maintenance_window" {
  type = string
}

variable "backup_window" {
  type = string
}

variable "monitoring_interval" {
  type = number
}

variable "monitoring_role_name" {
  type = string
}

variable "create_monitoring_role" {
  type = bool
}

variable "tags" {
  type = map(string)
}

variable "create_db_subnet_group" {
  type = bool
}

variable "subnet_ids" {
  type = list(string)
}

variable "family" {
  type = string
}

variable "major_engine_version" {
  type = string
}

variable "deletion_protection" {
  type = bool
}

variable "parameters" {
  type = list(map(string))
}
