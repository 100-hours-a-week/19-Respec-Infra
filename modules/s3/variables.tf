variable "bucket_name" {
  description = "Name of the S3 bucket"
  type        = string
}

variable "force_destroy" {
  description = "Whether to force destroy the bucket (including contents)"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to S3 bucket"
  type        = map(string)
  default     = {}
}

variable "bucket_policy" {
  description = "JSON policy to apply to the bucket"
  type        = string
}
