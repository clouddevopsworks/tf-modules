resource "aws_lb" "alb" {
  name               = "alb-${var.application}-${var.tags["environment"]}"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnets

  enable_deletion_protection = var.enable_deletion_protection

  tags = merge(tomap({
    Name = "alb-${var.application}-${var.tags["environment"]}",
    "environment" = "${var.tags["environment"]}"}),
    var.default_tags,
    var.tags
  )
}

