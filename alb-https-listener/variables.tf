variable "ssl_policy" {
  type        = string
  description = "Name of the SSL Policy for the listener"
}

variable "certificate_arn" {
  type        = string
  description = "ARN of the default SSL server certificate"
}

variable "application" {
  type        = string
  description = "comprehensinve application name"
}

variable "load_balancer_arn" {
  type        = string
  description = "ARN of the load balancer"
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