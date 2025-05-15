variable "pipeline_name" {
  description = "Name of the CodePipeline"
  type        = string
}

variable "pipeline_role_arn" {
  description = "IAM Role ARN for CodePipeline"
  type        = string
}

variable "artifact_bucket" {
  description = "S3 Bucket for CodePipeline artifacts"
  type        = string
}

variable "github_owner" {
  description = "GitHub Owner"
  type        = string
}

variable "github_repo" {
  description = "GitHub Repository"
  type        = string
}

variable "github_branch" {
  description = "GitHub Branch"
  type        = string
}

variable "github_token" {
  description = "GitHub OAuth Token"
  type        = string
  sensitive   = true
}

variable "codebuild_project_name" {
  description = "Name of the CodeBuild Project"
  type        = string
}

variable "codedeploy_app_name" {
  description = "Name of the CodeDeploy Application"
  type        = string
}

variable "codedeploy_deployment_group" {
  description = "Name of the CodeDeploy Deployment Group"
  type        = string
}
