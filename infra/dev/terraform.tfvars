name             = "specranking"
environment      = "dev"

# EC2 / Auto Scaling
ami_id           = "ami-05377cf8cfef186c2"
instance_type    = "t3.medium"
key_name         = "master"
desired_capacity = 1
min_size         = 1
max_size         = 2
image            = "123456789012.dkr.ecr.ap-northeast-2.amazonaws.com/specranking:latest"

# VPC
cidr_block       = "10.0.0.0/16"
azs              = ["ap-northeast-2a", "ap-northeast-2c"]
public_subnets   = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnets  = ["10.0.11.0/24", "10.0.21.0/24", "10.0.12.0/24", "10.0.22.0/24"]

# RDS
db_engine         = "mysql"
db_engine_version = "8.0.36"
db_instance_class = "db.t3.micro"
db_name           = "specranking"
db_username       = "sr_user"
db_password       = "vH4!zT9p$Km2"  # ⚠️ gitignore 또는 환경변수로 보호할 것

# CodePipeline / CodeBuild / S3
github_owner     = "19-Respec"
artifact_bucket  = "specranking-artifacts-dev"

region  = "ap-northeast-2"
profile = "default"  # 또는 "specranking-admin" 같은 커스텀 프로파일
