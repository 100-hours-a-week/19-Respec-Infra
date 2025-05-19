# 공통 인프라 명칭
variable "name" {
  description = "Name prefix for all resources"
  type        = string
}

# 환경명
variable "environment" {
  description = "Environment name (e.g. dev, prod)"
  type        = string
}

# EC2 관련
variable "ami_id" {
  description = "AMI ID to use for EC2"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "key_name" {
  description = "EC2 SSH key pair name"
  type        = string
}

variable "subnet_ids" {
  description = "Subnet IDs for EC2 Auto Scaling Group"
  type        = list(string)
}

variable "desired_capacity" {
  type        = number
  description = "ASG desired instance count"
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

variable "image" {
  description = "Docker image to pull in EC2"
  type        = string
}

# VPC
variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
}

variable "public_subnets" {
  description = "CIDRs for public subnets"
  type        = list(string)
}

variable "private_subnets" {
  description = "CIDRs for private subnets"
  type        = list(string)
}

# RDS 관련
variable "db_engine" {
  type    = string
  default = "postgres"
}

variable "db_engine_version" {
  type    = string
  default = "14.10"
}

variable "db_instance_class" {
  type    = string
  default = "db.t3.micro"
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

# S3/CloudFront
variable "artifact_bucket" {
  description = "Artifact S3 bucket name for CodePipeline/CodeBuild"
  type        = string
}

# CodeBuild & CodePipeline
variable "repo_name" {
  description = "GitHub repository name"
  type        = string
}

variable "github_owner" {
  description = "GitHub 사용자 또는 조직명"
  type        = string
}
