data "template_file" "bootstrap" {
  template = file("${path.module}/templates/${var.tags["environment"]}/${var.application_name}/rule.tpl")
  vars = {
    clusterarn = var.clusterarn
  }
}

resource "aws_cloudwatch_event_rule" "cloudwatch_event_rule" {
  name          = "cw-event-rule-${var.application_name}-${var.service}-${var.accessibility}-${var.tags["environment"]}"
  event_pattern = data.template_file.bootstrap.rendered
  role_arn      = var.event_rule_iam_role
  tags = merge(var.tags,
    var.default_tags,
    map(
      "Name", "cw-event-rule-${var.application_name}-${var.service}-${var.accessibility}-${var.tags["environment"]}",
      "service", "${var.service}"
  ))

}

resource "aws_cloudwatch_event_target" "lambda_event_target" {
  rule = aws_cloudwatch_event_rule.cloudwatch_event_rule.name
  arn  = aws_lambda_function.ecs_task_alert_lambda.arn
  depends_on = [
    aws_cloudwatch_event_rule.cloudwatch_event_rule,
    aws_lambda_function.ecs_task_alert_lambda
  ]
}

data "archive_file" "files" {
  type        = "zip"
  source_dir  = "${path.module}/files/${var.tags["environment"]}/${var.application_name}"
  output_path = "${path.module}/myzip/${var.tags["environment"]}/${var.application_name}/python.zip"
}

resource "aws_lambda_function" "ecs_task_alert_lambda" {
  filename         = "${path.module}/myzip/${var.tags["environment"]}/${var.application_name}/python.zip"
  source_code_hash = filebase64sha256("${path.module}/myzip/${var.tags["environment"]}/${var.application_name}/python.zip")
  function_name    = "lambda-ecs-task-alerts-${var.application_name}-${var.service}-${var.accessibility}-${var.tags["environment"]}"
  handler          = "index.lambda_handler"
  runtime          = "python3.7"
  role             = var.lambda_iam_role
  publish          = true
  kms_key_arn      = var.kms_key_arn

  depends_on = [
    aws_cloudwatch_event_rule.cloudwatch_event_rule
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
      "Name", "lambda-ecs-task-alerts-${var.application_name}-${var.service}-${var.accessibility}-${var.tags["environment"]}",
      "service", "${var.service}"
  ))
}

resource "aws_cloudwatch_log_group" "cloudwatch_log_group" {
  name              = "/aws/lambda/lambda-ecs-task-alerts-${var.application_name}-${var.service}-${var.accessibility}-${var.tags["environment"]}"
  retention_in_days = 7
}

resource "aws_lambda_permission" "lambda_trigger" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = "lambda-ecs-task-alerts-${var.application_name}-${var.service}-${var.accessibility}-${var.tags["environment"]}"
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.cloudwatch_event_rule.arn
}

/* resource "aws_cloudwatch_log_group" "lambda_aws_cloudwatch_log_group" {
  name              = "log-group-lambda-ecs-task-alerts-${var.application_name}-${var.service}-${var.accessibility}-${var.tags["environment"]}"
  retention_in_days = 1
} */