provider "aws" {
  region = var.region
}

resource "aws_s3_bucket" "tfstate_new" {
  bucket = var.bucket_name
  force_destroy = true
  tags = {
    Name        = "Terraform State Bucket"
    Environment = "bootstrap"
  }

  versioning {
    enabled = true
  }

  lifecycle {
    prevent_destroy = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}
