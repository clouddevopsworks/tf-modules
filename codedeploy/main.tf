resource "aws_codedeploy_app" "codedeploy_app" {
  name             = "codedeploy-${var.application}-${var.tags["environment"]}"
  compute_platform = "ECS"

  tags = merge(tomap({
    Name = "codedeploy-${var.application}-${var.tags["environment"]}",
    "environment" = "${var.tags["environment"]}" }),
    var.default_tags,
    var.tags
  )
}


resource "aws_codedeploy_deployment_group" "codedeploy_deployment_group" {
  app_name               = aws_codedeploy_app.codedeploy_app.name
  deployment_config_name = var.deployment_config_name
  deployment_group_name  = "dg-${var.application}-${var.tags["environment"]}"
  service_role_arn       = var.service_role_arn

  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout = "CONTINUE_DEPLOYMENT"
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = var.termination_wait_time_in_minutes
    }
  }

  deployment_style {
    deployment_option = "WITH_TRAFFIC_CONTROL"
    deployment_type   = "BLUE_GREEN"
  }

  ecs_service {
    cluster_name = var.cluster_name
    service_name = var.service_name
  }

  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = var.listener_arns
      }

      /* test_traffic_route {
        listener_arns = var.listener_arns
      } */

      target_group {
        name = var.blue_target_group_name
      }

      target_group {
        name = var.green_target_group_name
      }
    }
  }


  /* trigger_configuration {
    trigger_events = [
      "DeploymentSuccess",
      "DeploymentFailure",
    ]

    trigger_name       = data.external.commit_message.result["message"]
    trigger_target_arn = var.sns_topic_arn
  } */
  lifecycle {
    ignore_changes = [blue_green_deployment_config]
  }

  tags = merge(tomap({
    Name = "cd-config-${var.application}-${var.tags["environment"]}",
    "environment" = "${var.tags["environment"]}" }),
    var.default_tags,
    var.tags
  )
}