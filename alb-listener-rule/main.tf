resource "aws_lb_listener_rule" "listener_rule" {
  listener_arn = var.listener_arn

  action {
    type             = "forward"
    target_group_arn = var.target_group_arn
  }

  condition {
    path_pattern {
      values = var.path_pattern
    }
  }

  condition {
    host_header {
      values = var.host_header
    }
  }
}