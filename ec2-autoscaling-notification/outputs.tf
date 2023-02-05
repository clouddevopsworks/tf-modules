output "ec2_autoscaling_notification" {
  value = aws_autoscaling_notification.ec2_autoscaling_notification.notifications
}