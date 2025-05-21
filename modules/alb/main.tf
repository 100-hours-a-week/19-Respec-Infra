


resource "aws_lb" "this" {
  name                       = var.name
  load_balancer_type         = var.type
  subnets                    = var.subnets
  security_groups            = var.security_groups
  internal                   = var.internal
  enable_deletion_protection = var.enable_deletion_protection
  tags                       = var.tags
}

resource "aws_lb_target_group" "this" {
  name        = var.target_group_name
  port        = var.target_group_port
  protocol    = var.target_group_protocol
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    path                = var.health_check_path
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200"
  }

  tags = var.tags
}

# ✅ HTTP 리스너 (80번 포트, 리디렉션 또는 포워딩 선택)
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.this.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

# ✅ HTTPS 리스너 (443번 포트, SSL 인증서 필요)
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.this.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_certificate_arn   # 👈 ACM 인증서 ARN 전달 필요

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this.arn
  }
}

resource "aws_lb_target_group" "fe" {
  name     = "${var.name}-fe-tg"
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = var.vpc_id
  target_type = "instance"

  health_check {
    path = var.health_check_path
  }
}

resource "aws_lb_target_group" "be" {
  name     = "${var.name}-be-tg"
  port     = var.target_group_port
  protocol = var.target_group_protocol
  vpc_id   = var.vpc_id
  target_type = "instance"

  health_check {
    path = var.health_check_path
  }
}
