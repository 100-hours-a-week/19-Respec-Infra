resources "aws_lb" "this" {

    name = var.name
    load_balancer_type = var.type
    subnets = var.subnets
    security_groups = var.security_groups
    internal = var.internal
    enable_deletion_protection = var.enable_deletion_protection

    tags = var.tags


}

resources "aws_lb_target_group" "this" {

    name = var.target_group_name
    port = var.target_group_port
    protocol = var.target_group_protocol
    vpc_id = var.vpc_id
    target_type = "instance"

    
    health_check {

        path = var.health_check_path
        interval = 30
        timeout = 5
        healthy_threshold = 3
        unhealthy_threshold = 3
        matcher = "200"
    }

    tags = var.tags
}

resources "aws_lb_listener" "http" {

    load_balancer_arn = aws_lb.this.arn
    port = 80
    protocol = "HTTP"

    default_action {

        type = "forward"
        target_group_arn = aws_lb_target_group.this.arn

    }
}