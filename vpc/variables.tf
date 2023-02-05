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

variable "availability_zone" {
  type        = list(string)
  description = "The AZ for the subnet"
}

variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block for the VPC"
}

variable "domain_name" {
  type        = string
  description = "The suffix domain name to use by default when resolving non Fully Qualified Domain Names"
}

variable "public_subnet" {
  type        = list(string)
  description = "The CIDR block for the subnet"
}

variable "private_subnet" {
  type        = list(string)
  description = "The CIDR block for the subnet"
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