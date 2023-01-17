variable "application" {
  type        = string
  description = "comprehensinve application name"
}

variable "taskdefinition_arn" {
  type        = string
  description = "task definition arn"
}

variable "containername" {
  type        = string
  description = "name of the container as defined in the ecs task"
}

variable "containerport" {
  type        = number
  description = "container port as defined in ecs task"
}

variable "filename" {
  type        = string
  description = "full path of the appspec.yml"
}