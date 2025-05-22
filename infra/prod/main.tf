resource "aws_s3_bucket_policy" "allow_cloudfront" {
  bucket = module.s3.bucket_id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${module.s3.bucket_arn}/*"
      Condition = {
        StringEquals = {
          "AWS:SourceArn" = module.cloudfront.cloudfront_distribution_arn
        }
      }
    }]
  })
}

module "ec2" {
  source           = "../../modules/ec2"
  name             = var.name
  ami_id           = var.ami_id
  instance_type    = var.instance_type
  key_name         = var.key_name
  subnet_ids       = module.vpc.private_subnet_ids
  desired_capacity = var.desired_capacity
  min_size         = var.min_size
  max_size         = var.max_size
  environment      = var.environment
}

module "vpc" {
  source = "../../modules/vpc"

  env                      = var.environment
  cidr_block               = var.cidr_block
  azs                      = var.azs
  public_subnet_cidrs      = ["10.0.1.0/24", "10.0.2.0/24"]
  private_app_subnet_cidrs = ["10.0.11.0/24", "10.0.21.0/24"]
  private_db_subnet_cidrs  = ["10.0.12.0/24", "10.0.22.0/24"]
}


module "cloudfront" {
  source = "../../modules/cloudfront"

  name                   = "${var.name}-frontend-${var.environment}"
  s3_bucket_domain_name  = module.s3.bucket_domain_name
  environment            = var.environment
}

module "s3" {
  source                     = "../../modules/s3"
  bucket_name                = "${var.name}-logging-${var.environment}"
  versioning                 = true
  force_destroy              = false
  enable_logging             = true
  environment                = var.environment

  logging_target_bucket      = "${var.name}-accesslog-${var.environment}" # 👈 추가
}


module "alb" {
  source              = "../../modules/alb"
  name                = var.name
  vpc_id              = module.vpc.vpc_id
  subnets             = module.vpc.public_subnet_ids   # ✅ public_subnets → subnets
  security_groups     = [module.vpc.alb_sg_id]         # ✅ 보안 그룹 ID 넘기기
  target_group_name   = "${var.name}-tg-${var.environment}"
  target_group_port   = 80                             # ✅ 기본 HTTP 포트 예시
  acm_certificate_arn = var.acm_certificate_arn        # ✅ HTTPS 인증서 ARN
  tags = {
    Name        = "alb-${var.environment}"
    Environment = var.environment
  }
}


module "rds" {
  source              = "../../modules/rds"
  name                = "${var.name}-db-${var.environment}"
  engine              = var.db_engine
  engine_version      = var.db_engine_version
  instance_class      = var.db_instance_class
  db_name             = var.db_name
  username            = var.db_username
  password            = var.db_password           # tfvars 또는 환경변수로 주입
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [module.vpc.rds_sg_id]
  environment         = var.environment
  monitoring_interval = 0
  monitoring_role_arn = "null"

  tags = {
    Name        = "specranking-rds"
    Environment = var.environment
  }
}


module "ecr_frontend" {
  source           = "../../modules/ecr"
  repository_name  = "${var.name}-backend-${var.environment}"
  scan_on_push     = true
  tags = {
    Environment = var.environment
    Service     = "backend"
  }
}


module "ecr_backend" {
  source           = "../../modules/ecr"
  repository_name  = "${var.name}-backend-${var.environment}"
  scan_on_push     = true
  tags = {
    Environment = var.environment
    Service     = "backend"
  }
}


module "deploy_fe" {
  source                 = "../../modules/codedeploy"
  app_name               = "respec-fe-codedeploy"
  deployment_group_name  = "respec-fe-deploy-group"
  ec2_tag_value          = "respec-fe-instance"
  target_group_name      = module.alb.fe_target_group_name
}


module "deploy_be" {
  source                 = "../../modules/codedeploy"
  app_name               = "respec-be-codedeploy"
  deployment_group_name  = "respec-be-deploy-group"
  ec2_tag_value          = "respec-be-instance"
  target_group_name      = module.alb.be_target_group_name
}


