variable "bucket_name" {
  description = "The name of the S3 bucket"
  type        = string
}

variable "region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "ap-northeast-2"  # 기본값도 가능
}
