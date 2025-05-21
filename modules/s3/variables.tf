variable "bucket_name" {
  type = string
}

variable "versioning" {
  type    = bool
  default = true
}

variable "force_destroy" {
  type    = bool
  default = false
}

variable "enable_logging" {
  type    = bool
  default = false
}

variable "logging_target_bucket" {
  type    = string
  default = "" # 로그용 버킷을 따로 만들 경우 지정
}

variable "environment" {
  type = string
}

variable "cloudfront_distribution_arn" {
  description = "CloudFront 배포의 ARN"
  type        = string
  default     = null  # 선택적 사용을 원한다면 default 추가 가능
}
