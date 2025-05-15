resource "aws_codebuild_project" "this" {
  name         = var.project_name
  service_role = var.service_role_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = var.compute_type
    image                       = var.build_image
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true # Docker build 위해 필요
    environment_variable {
      name  = "REPOSITORY_URI"
      value = var.ecr_repository_url
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = var.buildspec_file
  }

  cache {
    type = "LOCAL"
  }

  logs_config {
    cloudwatch_logs {
      group_name = "/codebuild/${var.project_name}"
      stream_name = "build-logs"
    }
  }

  tags = var.tags
}
