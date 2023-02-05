output "scaling_policy_name" {
  value = aws_appautoscaling_policy.ecs_policy.name
}

output "scaling_policy_arn" {
  value = aws_appautoscaling_policy.ecs_policy.arn
}
