resource "aws_lb_listener" "lb_listener_redirect" {
  count             = var.redirect == true ? 1 : 0
  load_balancer_arn = var.load_balancer_arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = merge(tomap({
    Name = "alb-http-listener-${var.application}-${var.tags["environment"]}",
    "environment" = "${var.tags["environment"]}" }),
    var.default_tags,
    var.tags
  )

}

resource "aws_lb_listener" "http_lb_listener" {
  count             = var.redirect == false ? 1 : 0
  load_balancer_arn = var.load_balancer_arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Please check your URL"
      status_code  = "200"
    }
  }

  tags = merge(tomap({
    Name = "alb-http-listener-${var.application}-${var.tags["environment"]}",
    "environment" = "${var.tags["environment"]}" }),
    var.default_tags,
    var.tags
  )

}