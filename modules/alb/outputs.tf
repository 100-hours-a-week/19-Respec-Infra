output "alb_dns_name" {

    description = "DNS name of the ALB"
    value = aws_lb.this.dns_name

}

output "target_group_arn" {

    description = "ARN of the target group"
    value = aws_lb_target_group.this.arn
}

output "fe_target_group_name" {
  value = aws_lb_target_group.fe.name
}

output "be_target_group_name" {
  value = aws_lb_target_group.be.name
}
