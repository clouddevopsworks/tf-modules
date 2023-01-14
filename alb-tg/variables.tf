variable "application" {
  type        = string
  description = "An indication whether identify the appliction"
}

variable "vpc_id" {
  type        = string
  description = "The identifier of the VPC in which to create the target group"
}

variable "target_type" {
  type        = string
  default     = "ip"
  description = "The type of target that you must specify when registering targets with this target group"
}

variable "enabled_stickiness" {
  type        = bool
  default     = false
  description = "Boolean to enable / disable stickiness"
}

variable "stickiness_cookie_duration" {
  type        = number
  default     = 86400
  description = "Only used when the type is lb_cookie. The time period, in seconds, during which requests from a client should be routed to the same target"
}

variable "health_check_healthy_threshold" {
  type        = number
  default     = 3
  description = "The number of consecutive health checks successes required before considering an unhealthy target healthy"
}

variable "health_check_unhealthy_threshold" {
  type        = number
  default     = 10
  description = "The number of consecutive health check failures required before considering the target unhealthy"
}

variable "health_check_timeout" {
  type        = number
  default     = 5
  description = "The amount of time, in seconds, during which no response means a failed health check"
}

variable "health_check_interval" {
  type        = number
  default     = 10
  description = "The approximate amount of time, in seconds, between health checks of an individual target"
}

variable "health_check_path" {
  type        = string
  description = "The destination for the health check request"
}

variable "health_check_port" {
  type        = string
  default     = "traffic-port"
  description = "The port to use to connect with the target"
}

variable "http_response_code" {
  type        = string
  default     = "200"
  description = "The HTTP codes to use when checking for a successful response from a target"
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