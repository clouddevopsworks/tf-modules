resource "aws_ecs_service" "ecs_service" {
  name                   = "ecs-service-${var.application}-${var.tags["environment"]}"
  cluster                = var.cluster_name
  task_definition        = var.task_definition_arn
  desired_count          = var.desired_count
  force_new_deployment   = true
  enable_execute_command = true
  scheduling_strategy    = "REPLICA"
  launch_type            = "FARGATE"
  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }

  deployment_controller {
    type = "CODE_DEPLOY"
  }

  /* ordered_placement_strategy {
    type = "spread"
  } */

  network_configuration {
    security_groups  = var.security_groups
    subnets          = var.subnets
    assign_public_ip = var.assign_public_ip
  }

  capacity_provider_strategy {
    capacity_provider = "FARGATE_SPOT"
    weight            = 100
    base              = 1
  }

  lifecycle {
    ignore_changes = [
      load_balancer,
      desired_count,
      task_definition,
    ]
  }

  tags = merge(tomap({
    Name = "ecs-service-${var.application}-${var.tags["environment"]}",
    "environment" = "${var.tags["environment"]}" }),
    var.default_tags,
    var.tags
  )
}
