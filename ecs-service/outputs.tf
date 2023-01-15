output "service_name" {
  value = aws_ecs_service.ecs_service.name
}

output "service_arn" {
  value = aws_ecs_service.ecs_service.id
}
