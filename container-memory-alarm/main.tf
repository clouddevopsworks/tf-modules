resource "aws_cloudwatch_metric_alarm" "memory_alarm" {
  alarm_name                = "cw-ecs-memory-alarm-${var.application_name}-${var.service}-${var.accessibility}-${var.tags["environment"]}"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = var.memory_monitor_period
  threshold                 = var.memory_threshold
  insufficient_data_actions = []
  alarm_actions             = [aws_sns_topic.tf_aws_sns_topic_with_subscription.arn]
  ok_actions                = [aws_sns_topic.tf_aws_sns_topic_with_subscription.arn]


metric_query {
    id          = "m0"
    label       = "cw-ecs-memory-alarm-${var.application_name}-${var.service}-${var.accessibility}-${var.tags["environment"]}"
    return_data = "true"

    metric {
      metric_name = "MemoryUtilization"
      namespace   = "AWS/ECS"
      period      = "120"
      stat        = "Average"
      unit        = "Percent"

      dimensions = {
        ClusterName = var.ecs_clustername
        ServiceName = var.ecs_servicename
      }
    }
  }


  /* metric_query {
    id          = "m0"
    expression  = "m2*100/m1"
    label       = "cw-ecs-memory-alarm-${var.application_name}-${var.service}-${var.accessibility}-${var.tags["environment"]}"
    return_data = "true"
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "MemoryReserved"
      namespace   = "ECS/ContainerInsights"
      period      = "120"
      stat        = "Sum"

      dimensions = {
        ClusterName = var.ecs_clustername
        ServiceName = var.ecs_servicename
      }
    }
  }

  metric_query {
    id = "m2"

    metric {
      metric_name = "MemoryUtilized"
      namespace   = "ECS/ContainerInsights"
      period      = "120"
      stat        = "Sum"

      dimensions = {
        ClusterName = var.ecs_clustername
        ServiceName = var.ecs_servicename
      }
    }
  } */

  tags = merge(var.tags,
    var.default_tags,
    map(
      "Name", "cw-ecs-memory-alarm-${var.application_name}-${var.service}-${var.accessibility}-${var.tags["environment"]}",
      "service", "${var.service}"
  ))
}

resource "aws_sns_topic" "tf_aws_sns_topic_with_subscription" {
  name = "sns-ecs-memory-alarm-alerts-${var.application_name}-${var.service}-${var.accessibility}-${var.tags["environment"]}"
  tags = merge(var.tags,
    var.default_tags,
    map(
      "Name", "sns-ecs-memory-alarm-alerts-${var.application_name}-${var.service}-${var.accessibility}-${var.tags["environment"]}",
      "service", "${var.service}"
  ))
}

resource "aws_sns_topic_subscription" "topic_subscription" {
  topic_arn = aws_sns_topic.tf_aws_sns_topic_with_subscription.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.ecs_memory_alert_lambda.arn
}

data "archive_file" "files" {
  type        = "zip"
  source_dir  = "${path.module}/files/${var.tags["environment"]}/${var.application_name}"
  output_path = "${path.module}/myzip/${var.tags["environment"]}/${var.application_name}/python.zip"
}

resource "aws_lambda_function" "ecs_memory_alert_lambda" {
  filename         = "${path.module}/myzip/${var.tags["environment"]}/${var.application_name}/python.zip"
  source_code_hash = filebase64sha256("${path.module}/myzip/${var.tags["environment"]}/${var.application_name}/python.zip")
  function_name    = "lambda-ecs-memory-alerts-${var.application_name}-${var.service}-${var.accessibility}-${var.tags["environment"]}"
  handler          = "index.lambda_handler"
  runtime          = "python3.7"
  role             = var.lambda_iam_role
  publish          = true
  kms_key_arn      = var.kms_key_arn
  depends_on = [
    aws_sns_topic.tf_aws_sns_topic_with_subscription
  ]

  environment {
    variables = {
      HOOK_URL    = var.ms_teams_webhook,
      Environment = "aws-${var.tags["environment"]}"
    }
  }

  tags = merge(var.tags,
    var.default_tags,
    map(
      "Name", "lambda-ecs-memory-alerts-${var.application_name}-${var.service}-${var.accessibility}-${var.tags["environment"]}",
      "service", "${var.service}"
  ))
}

resource "aws_lambda_permission" "lambda_trigger" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = "lambda-ecs-memory-alerts-${var.application_name}-${var.service}-${var.accessibility}-${var.tags["environment"]}"
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.tf_aws_sns_topic_with_subscription.arn
}


resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name              = "/aws/lambda/lambda-ecs-memory-alerts-${var.application_name}-${var.service}-${var.accessibility}-${var.tags["environment"]}"
  retention_in_days = 7
}
