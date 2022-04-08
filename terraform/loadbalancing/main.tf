data "aws_autoscaling_group" "app_asg" {
  name = aws_autoscaling_group.app_asg.name
}

data "aws_acm_certificate" "ssl_cert" {
  domain = var.acm_cert_domain
}

resource "aws_lb" "web_alb" {
  name               = "webserver-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.web_security_group_ids
  subnets            = var.web_subnets
}

resource "aws_lb_listener" "web_alb_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = var.web_listener_port
  protocol          = var.web_protocol
  certificate_arn   = data.aws_acm_certificate.ssl_cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_alb_target_group.arn
  }
}

resource "aws_lb_listener_certificate" "ssl_cert" {
  listener_arn    = aws_lb_listener.web_alb_listener.arn
  certificate_arn = data.aws_acm_certificate.ssl_cert.arn
}

resource "aws_autoscaling_group" "app_asg" {
  depends_on = [
    var.gateway_endpoint_rt_association_id, var.rds_dns
  ]
  name                = "AppServer-ASG"
  max_size            = var.app_asg_max_size
  min_size            = var.app_asg_min_size
  desired_capacity    = var.app_asg_desired_capacity
  target_group_arns   = [aws_lb_target_group.app_alb_target_group.arn]
  vpc_zone_identifier = var.app_subnets
  health_check_type   = "EC2"
  launch_template {
    id      = var.app_launch_template_id
    version = "$Latest"
  }
  lifecycle {
    ignore_changes = [load_balancers, target_group_arns]
  }
}

resource "aws_autoscaling_attachment" "app_asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.app_asg.id
  lb_target_group_arn    = aws_lb_target_group.app_alb_target_group.arn
}

resource "aws_lb_target_group" "app_alb_target_group" {
  name     = "App-ALB-target-group"
  port     = var.app_port
  protocol = var.app_protocol
  vpc_id   = var.vpc_id
  lifecycle {
    create_before_destroy = true
  }
}
