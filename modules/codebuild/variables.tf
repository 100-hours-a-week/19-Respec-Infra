variable "project_name" {
  description = "CodeBuild 프로젝트 이름"
  type        = string
}

variable "service_role_arn" {
  description = "CodeBuild에 사용할 IAM Role ARN"
  type        = string
}

variable "compute_type" {
  description = "빌드 환경 타입 (예: BUILD_GENERAL1_SMALL)"
  type        = string
  default     = "BUILD_GENERAL1_SMALL"
}

variable "build_image" {
  description = "빌드에 사용할 Docker 이미지 (예: aws/codebuild/standard:7.0)"
  type        = string
}

variable "ecr_repository_url" {
  description = "ECR Repository URL"
  type        = string
}

variable "buildspec_file" {
  description = "CodeBuild에서 사용할 buildspec 파일 경로"
  type        = string
  default     = "buildspec.yml"
}

variable "tags" {
  description = "공통 태그"
  type        = map(string)
  default     = {}
}
