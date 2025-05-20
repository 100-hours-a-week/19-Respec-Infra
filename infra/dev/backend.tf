terraform {
  backend "s3" {
    bucket  = "specranking-bucket-dev"
    key     = "dev/terraform.tfstate"
    region  = "ap-northeast-2"
    encrypt = true
  }
}
