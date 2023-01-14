variable "application" {
  type        = string
  description = "comprehensinve application name"
}

variable "tags" {
  description = "aws resourse tags"
  type        = map(string)
}