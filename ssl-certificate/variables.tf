variable "domain_name" {
  type        = string
  description = "Fully qualified domain name (FQDN) in the certificate"
}

variable "subject_alternative_names" {
  type        = list(string)
  description = "The tag mutability setting for the repository"
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