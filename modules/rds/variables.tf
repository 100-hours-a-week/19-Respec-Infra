variable "name" {
  type        = string
  description = "RDS 식별자 및 네이밍용 prefix"
}

variable "engine" {
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  type        = string
  default     = "14.10"
}

variable "instance_class" {
  type        = string
  default     = "db.t3.medium"
}

variable "allocated_storage" {
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  type        = number
  default     = 100
}

variable "storage_type" {
  type        = string
  default     = "gp3"
}

variable "username" {
  type        = string
}

variable "password" {
  type        = string
  sensitive   = true
}

variable "db_name" {
  type        = string
}

variable "multi_az" {
  type        = bool
  default     = true
}

variable "storage_encrypted" {
  type        = bool
  default     = true
}

variable "kms_key_id" {
  type        = string
  default     = null
}

variable "subnet_ids" {
  type        = list(string)
}

variable "security_group_ids" {
  type        = list(string)
}

variable "backup_retention_period" {
  type        = number
  default     = 7
}

variable "backup_window" {
  type        = string
  default     = "03:00-04:00"
}

variable "maintenance_window" {
  type        = string
  default     = "Mon:04:00-Mon:05:00"
}

variable "deletion_protection" {
  type        = bool
  default     = true
}

variable "monitoring_interval" {
  type        = number
  default     = 60
}

variable "cloudwatch_logs_exports" {
  type        = list(string)
  default     = ["postgresql"]
}

variable "environment" {
  type        = string
}
