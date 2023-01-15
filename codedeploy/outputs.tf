output "codedeploy_app_name" {
  value = aws_codedeploy_app.codedeploy_app.name
}

output "codedeploy_config_name" {
  value = aws_codedeploy_deployment_group.codedeploy_deployment_group.id
}