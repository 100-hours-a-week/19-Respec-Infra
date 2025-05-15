variable "name" {
  description = "Name identifier for RDS instance"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for DB Subnet Group"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security Group IDs for RDS"
  type        = list(string)
}

variable "instance_class" {
  description = "RDS instance class (e.g., db.t3.micro)"
  type        = string
}

variable "allocated_storage" {
  description = "Allocated storage in GB"
  type        = number
}

variable "engine" {
  description = "Database engine (e.g., mysql, postgres)"
  type        = string
}

variable "engine_version" {
  description = "Engine version"
  type        = string
}

variable "username" {
  description = "Master username"
  type        = string
}

variable "password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "multi_az" {
  description = "Enable Multi-AZ deployment"
  type        = bool
  default     = false
}

variable "publicly_accessible" {
  description = "Make RDS publicly accessible"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags for RDS resources"
  type        = map(string)
}
