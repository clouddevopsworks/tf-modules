variable "application" {
  type        = string
  description = "comprehensinve application name"
}

variable "internal" {
  type        = bool
  description = "If true, the LB will be internal"
}

variable "security_groups" {
  type        = list(string)
  description = "A list of security group IDs to assign to the LB"
}

variable "subnets" {
  type        = list(string)
  description = "A list of subnet IDs to attach to the LB."
}

variable "enable_deletion_protection" {
  type        = bool
  description = "If true, deletion of the load balancer will be disabled via the AWS API"
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