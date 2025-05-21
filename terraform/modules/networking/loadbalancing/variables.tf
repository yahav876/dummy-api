variable "airflow_nlb_name" {
  description = "Name of the NLB"
  type        = string
}

variable "airflow_nlb_vpc_id" {
  description = "VPC ID for the NLB"
  type        = string
}

variable "airflow_nlb_subnets" {
  description = "List of subnets for the NLB"
  type        = list(string)
}

variable "airflow_nlb_internal" {
  description = "Whether the NLB is internal"
  type        = bool
  default     = false
}

variable "airflow_nlb_port" {
  description = "Listener port for the NLB"
  type        = number
}

variable "airflow_nlb_target_group_port" {
  description = "Port for the target group"
  type        = number
}

variable "airflow_nlb_target_group_protocol" {
  description = "Protocol for the target group"
  type        = string
}

variable "airflow_nlb_listener_protocol" {
  description = "Protocol for the listener"
  type        = string
}

variable "airflow_nlb_target_type" {
  description = "Target type (instance or ip)"
  type        = string
}

variable "airflow_nlb_target_ids" {
  description = "List of target IDs"
  type        = list(string)
}

variable "airflow_nlb_enable_cross_zone_load_balancing" {
  description = "Enable cross zone load balancing"
  type        = bool
  default     = true
}

variable "airflow_nlb_idle_timeout" {
  description = "Idle timeout for the NLB"
  type        = number
  default     = 60
}

variable "airflow_nlb_tags" {
  description = "Tags to apply to the NLB"
  type        = map(string)
}
