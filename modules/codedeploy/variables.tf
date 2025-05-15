variable "app_name" {
  description = "CodeDeploy Application Name"
  type        = string
}

variable "deployment_group_name" {
  description = "CodeDeploy Deployment Group Name"
  type        = string
}

variable "ec2_tag_value" {
  description = "EC2 Tag Value to target for deployment"
  type        = string
}

variable "target_group_name" {
  description = "ALB Target Group Name"
  type        = string
}
