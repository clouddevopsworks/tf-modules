variable "autoscaling_group_name" {
  type        = list(string)
  description = "A list of AutoScaling Group Names"
}

variable "sns_topic_arn" {
  type        = string
  description = "The Topic ARN for notifications to be sent through"
}