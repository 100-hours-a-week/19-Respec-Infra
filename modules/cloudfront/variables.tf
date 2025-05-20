variable "name" {
  type = string
}

variable "s3_bucket_domain_name" {
  type = string
  description = "S3 정적 웹사이트 도메인 (e.g., bucket-name.s3.amazonaws.com)"
}

variable "environment" {
  type = string
  default = "dev"
}

# optional
# variable "acm_certificate_arn" {
#   type    = string
#   default = null
# }
