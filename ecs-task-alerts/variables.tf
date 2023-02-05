variable "application_name" {
  type        = string
  description = "An indication to identify the appliction. Passed in the Name of the resourece"
}

variable "service" {
  type        = string
  default     = "dc"
  description = "An indication whether the resource is created on primary or dsaster recovery"
}

variable "accessibility" {
  type        = string
  default     = "prv"
  description = "An indication whether the resource is publicly accessed or not"
}

variable "event_rule_iam_role" {
  type = string
}

variable "lambda_iam_role" {
  type = string
}

variable "kms_key_arn" {
  type = string
}

variable "ms_teams_webhook" {
  type = string
}
variable "clusterarn" {
  type = string
}

variable "default_tags" {
  type        = map(string)
  default     = {}
  description = "Used as resource Tags"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Used as resource Tags"
}