variable "listener_arn" {
  type        = string
  description = "The ARN of the listener to which to attach the rule"
}

variable "target_group_arn" {
  type        = string
  description = "The ARN of the Target Group to which to route traffic"
}

variable "path_pattern" {
  type        = list(string)
  description = "Contains a single values item which is a list of path patterns to match against the request URL"
}

variable "host_header" {
  type        = list(string)
  description = "Contains a single values item which is a list of host header patterns to match"

}