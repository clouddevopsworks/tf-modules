variable "private_zone" {
  type        = bool
  default     = true
  description = "Specify whether to create a public or private dns zone"
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

variable "domain_name" {
  type        = string
  description = "	This is the name of the hosted zone"
}

variable "vpc_id" {
  type        = string
  description = "Configuration block(s) specifying VPC(s) to associate with a private hosted zone"
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