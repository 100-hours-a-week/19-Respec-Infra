output "vpc_id" {
  value = aws_vpc.main.id
}

output "public_subnets" {
  value = aws_subnet.public[*].id
}

output "private_app_subnets" {
  value = aws_subnet.private_app[*].id
}

output "private_db_subnets" {
  value = aws_subnet.private_db[*].id
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "private_subnet_ids" {
  description = "Private subnets to be used by EC2 Auto Scaling"
  value       = concat(
    aws_subnet.private_app[*].id,
    aws_subnet.private_db[*].id
  )
}

output "public_subnet_ids" {
  value = aws_subnet.public[*].id
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "rds_sg_id" {
  value = aws_security_group.rds_sg.id
}
