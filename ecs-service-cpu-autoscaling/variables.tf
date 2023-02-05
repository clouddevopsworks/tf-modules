variable "application" {
  type        = string
  description = "comprehensinve application name"
}

variable "max_capacity" {
  type        = number
  description = "max number of tasks"
}

variable "min_capacity" {
  type        = number
  description = "min number of tasks"
}

variable "resource_id" {
  type        = string
  description = "service/clusterName/serviceName"
}

variable "target_value" {
  type        = number
  description = "arget value for the metric"
}

variable "scale_in_cooldown" {
  type        = number
  description = "Amount of time, in seconds, after a scale in activity completes before another scale in activity can start"
}

variable "scale_out_cooldown" {
  type        = number
  description = "mount of time, in seconds, after a scale out activity completes before another scale out activity can start"
}

variable "tags" {
  description = "aws resourse tags"
  type        = map(string)
}