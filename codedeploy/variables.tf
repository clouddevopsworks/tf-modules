variable "application" {
  type        = string
  description = "comprehensinve application name"
}

variable "deployment_config_name" {
  type        = string
  default     = "CodeDeployDefault.ECSAllAtOnce"
  description = "The name of the group's deployment config"
}

variable "service_role_arn" {
  type        = string
  description = "The service role ARN that allows deployments"
}

variable "cluster_name" {
  type        = string
  description = "The name of the ECS cluster"
}

variable "service_name" {
  type        = string
  description = "The name of the ECS service"
}

variable "listener_arns" {
  type        = list(string)
  description = "List of Amazon Resource Names (ARNs) of the load balancer listeners"
}

variable "blue_target_group_name" {
  type        = string
  description = "Name of the target group"
}

variable "green_target_group_name" {
  type        = string
  description = "Name of the target group"
}

variable "tags" {
  description = "aws resourse tags"
  type        = map(string)
}

variable "default_tags" {
  description = "defult aws resourse tags"
  type        = map(string)
  default = {
    "createby" = "terraform"
  }
}