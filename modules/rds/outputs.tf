output "endpoint" {
  description = "RDS Endpoint"
  value       = aws_db_instance.this.endpoint
}

output "arn" {
  description = "RDS Instance ARN"
  value       = aws_db_instance.this.arn
}
