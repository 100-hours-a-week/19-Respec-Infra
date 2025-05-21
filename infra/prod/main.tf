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

  name                   = "${var.name}-frontend-dev"
  s3_bucket_domain_name  = module.s3.bucket_domain_name
  environment            = var.environment
}

module "s3" {
  source                     = "../../modules/s3"
  bucket_name                = "${var.name}-bucket-prod"
  versioning                 = true
  force_destroy              = false
  enable_logging             = true
  environment                = var.environment

}

module "alb" {
  source              = "../../modules/alb"
  name                = var.name
  vpc_id              = module.vpc.vpc_id
  subnets             = module.vpc.public_subnet_ids   # ✅ public_subnets → subnets
  security_groups     = [module.vpc.alb_sg_id]         # ✅ 보안 그룹 ID 넘기기
  target_group_name   = "${var.name}-tg-prod"
  target_group_port   = 80                             # ✅ 기본 HTTP 포트 예시
  acm_certificate_arn = var.acm_certificate_arn        # ✅ HTTPS 인증서 ARN
  tags = {
    Name        = "alb-${var.environment}"
    Environment = var.environment
  }
}


module "rds" {
  source              = "../../modules/rds"
  name                = "${var.name}-db-prod"
  engine              = var.db_engine
  engine_version      = var.db_engine_version
  instance_class      = var.db_instance_class
  db_name             = var.db_name
  username            = var.db_username
  password            = var.db_password           # tfvars 또는 환경변수로 주입
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [module.vpc.rds_sg_id]
  environment         = var.environment
  tags = {
    Name        = "specranking-rds"
    Environment = var.environment
  }
}


# Frontend
module "build_fe" {
  source              = "../../modules/codebuild"
  project_name        = "19-Respec-FE-build"
  service_role_arn    = var.codebuild_service_role_arn
  build_image         = "aws/codebuild/standard:5.0"
  ecr_repository_url  = "123456789012.dkr.ecr.ap-northeast-2.amazonaws.com/specranking-frontend"
}


module "deploy_fe" {
  source                 = "../../modules/codedeploy"
  app_name               = "respec-fe-codedeploy"
  deployment_group_name  = "respec-fe-deploy-group"
  ec2_tag_value          = "respec-fe-instance"
  target_group_name      = module.alb.fe_target_group_name
}

# module "pipeline_fe" {
#   source             = "../../modules/codepipeline"
#   name               = "respec-fe-pipeline"
#   github_owner       = var.github_owner
#   github_repo        = "19-Respec-FE"
#   github_branch      = "prod"
#   codedeploy_app     = module.deploy_fe.app_name
#   deployment_group   = module.deploy_fe.deployment_group_name
#   codebuild_project  = module.build_fe.project_name
#   artifact_bucket    = var.artifact_bucket
# }

# Backend
module "build_be" {
  source              = "../../modules/codebuild"
  project_name        = "19-Respec-BE-build"  
  build_image         = "aws/codebuild/standard:5.0"
  ecr_repository_url  = "123456789012.dkr.ecr.ap-northeast-2.amazonaws.com/specranking"
  service_role_arn    = var.codebuild_service_role_arn
}

module "deploy_be" {
  source                 = "../../modules/codedeploy"
  app_name               = "respec-be-codedeploy"
  deployment_group_name  = "respec-be-deploy-group"
  ec2_tag_value          = "respec-be-instance"
  target_group_name      = module.alb.be_target_group_name
}

module "pipeline_be" {
  source                     = "../../modules/codepipeline"

  pipeline_name              = "respec-be-pipeline"
  pipeline_role_arn          = var.pipeline_role_arn
  artifact_bucket            = var.artifact_bucket

  github_owner               = var.github_owner
  github_repo                = "19-Respec-BE"
  github_branch              = "prod"
  github_token               = var.github_token

  codebuild_project_name     = module.build_be.project_name
  codedeploy_app_name        = module.deploy_be.app_name
  codedeploy_deployment_group = module.deploy_be.deployment_group_name
}

# # AI
# module "build_ai" {
#   source           = "../../modules/codebuild"
#   project_name     = "respec-ai-build"
#   repo_name        = "19_Respec-AI"
#   branch           = "main"
#   artifact_bucket  = var.artifact_bucket
#   environment_variables = { ENV = "dev" }
# }

# module "pipeline_ai" {
#   source             = "../../modules/codepipeline"
#   name               = "respec-ai-pipeline"
#   github_owner       = var.github_owner
#   github_repo        = "19_Respec-AI"
#   github_branch      = "main"
#   # AI는 CodeDeploy 없이도 배포 가능 (예: Docker push → GCP, Lambda 등)
#   codebuild_project  = module.build_ai.project_name
#   artifact_bucket    = var.artifact_bucket
# }
