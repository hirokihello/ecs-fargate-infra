resource "aws_alb" "hirokihello" {
  name            = "hirokihello-${var.stage}-alb"
  internal        = false
  security_groups = [aws_security_group.alb.id]
  subnets         = [
                  for subnet in aws_subnet.public:
                  subnet.id
                ]

  enable_deletion_protection = false

  tags = {
    Environment = var.stage
  }

  access_logs {
    bucket = "hirokihello-alb-logs"
    prefix = "hirokihello-${var.stage}-alb"
  }
}

resource "aws_alb_listener" "hirokihello-http" {
  load_balancer_arn = aws_alb.hirokihello.arn
  port = "80"
  protocol = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_alb_listener" "hirokihello-https" {
  load_balancer_arn = aws_alb.hirokihello.arn
  port = "443"
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2015-05"
  certificate_arn = aws_acm_certificate.cert-production-alb.arn

  default_action {
    target_group_arn = aws_alb_target_group.hirokihello-app.arn
    type = "forward"
  }
}

resource "aws_alb_target_group" "hirokihello-app" {
  name     = "hirokihello-${var.stage}-app"
  port     = 80
  target_type = "ip"
  protocol = "HTTP"
  vpc_id   = aws_vpc.hirokihello.id
  deregistration_delay = 30

  health_check {
    interval            = 30
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    timeout             = 5
    unhealthy_threshold = 2
    matcher             = "200-299"
  }
}

resource "aws_acm_certificate" "cert-production-alb" {
  domain_name       = var.domain_name
  subject_alternative_names  = ["*.${var.domain_name}"]
  validation_method = "DNS"
  provider          = "aws.tokyo"
}
