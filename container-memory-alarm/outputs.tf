output "memory_alarm_arn" {
  value = aws_cloudwatch_metric_alarm.memory_alarm.arn
}