output "asg_id" {
  value = aws_autoscaling_group.autoscaling_group.id
}

output "asg_arn" {
  value = aws_autoscaling_group.autoscaling_group.arn
}