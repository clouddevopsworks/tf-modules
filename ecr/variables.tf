variable "application" {
  type        = string
  description = "comprehensinve application name"
}

variable "tag_mutability" {
  type        = string
  description = "The tag mutability setting for the repository"
  default     = "MUTABLE"
}

variable "scan" {
  type        = bool
  description = "Indicates whether images are scanned after being pushed to the repository"
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