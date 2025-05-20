output "project_name" {
  description = "CodeBuild [프로젝트 명]"
  value       = aws_codebuild_project.this.name
}
