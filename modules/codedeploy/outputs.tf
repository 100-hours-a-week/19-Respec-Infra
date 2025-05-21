output "app_name" {
  description = "CodeDeploy Application Name"
  value       = aws_codedeploy_app.this.name
}

output "deployment_group_name" {
  description = "CodeDeploy Deployment Group Name"
  value       = aws_codedeploy_deployment_group.this.deployment_group_name
}
