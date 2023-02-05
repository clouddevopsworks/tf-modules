output "cloudwatch_event_rule_name" {
  value = aws_cloudwatch_event_rule.cloudwatch_event_rule.name
}

output "lambda_arn" {
  value = aws_lambda_function.ecs_task_alert_lambda.arn
}