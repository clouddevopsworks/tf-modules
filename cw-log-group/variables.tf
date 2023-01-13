variable "log_group_name" {
  type        = string
  description = "comprehensinve log group name"
}

variable "retention_days" {
  type        = number
  description = " Specifies the number of days you want to retain log events in the specified log group"
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