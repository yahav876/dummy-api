variable "vpc_id" {
  type        = string
  description = "VPC ID where the NLB will be deployed"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the NLB"
}

variable "internal" {
  type        = bool
  description = "Whether the NLB is internal"
  default     = false
}

variable "tcp_enabled" {
  type        = bool
  description = "Enable TCP listeners"
  default     = true
}

variable "access_logs_enabled" {
  type        = bool
  description = "Enable access logs"
  default     = false
}

variable "nlb_access_logs_s3_bucket_force_destroy" {
  type        = bool
  default     = false
}

variable "nlb_access_logs_s3_bucket_force_destroy_enabled" {
  type        = bool
  default     = false
}

variable "cross_zone_load_balancing_enabled" {
  type        = bool
  default     = true
}

variable "idle_timeout" {
  type        = number
  default     = 60
}

variable "ip_address_type" {
  type        = string
  default     = "ipv4"
}

variable "deletion_protection_enabled" {
  type        = bool
  default     = false
}

variable "deregistration_delay" {
  type        = number
  default     = 300
}

variable "health_check_path" {
  type        = string
  default     = "/"
}

variable "health_check_timeout" {
  type        = number
  default     = 5
}

variable "health_check_threshold" {
  type        = number
  default     = 3
}

variable "health_check_unhealthy_threshold" {
  type        = number
  default     = 3
}

variable "health_check_interval" {
  type        = number
  default     = 30
}

variable "target_group_port" {
  type        = number
}

variable "target_group_target_type" {
  type        = string
  default     = "ip"
}
