terraform {
  backend "s3" {
    bucket  = "specranking-bucket-prod"
    key     = "prod/terraform.tfstate"
    region  = "ap-northeast-2"
    encrypt = true
  }
}
