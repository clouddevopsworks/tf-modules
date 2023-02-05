output "cpu_alarm_arn" {
  value = aws_cloudwatch_metric_alarm.cpu_alarm.arn
}