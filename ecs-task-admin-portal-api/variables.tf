variable "application" {
  type        = string
  description = "comprehensinve application name"
}

variable "registry" {
  type        = string
  description = "docker registry URL"
}

variable "db_password" {
  type        = string
  description = "environmental varibale"
}

variable "mail_password" {
  type        = string
  description = "environmental varibale"
}

variable "aws_secret_access_key" {
  type        = string
  description = "environmental varibale"
}

variable "rollbar_access_token" {
  type        = string
  description = "environmental varibale"
}

variable "cpu_app" {
  type        = number
  description = "Number of cpu units used by app"
}

variable "memory_app" {
  type        = number
  description = "Amount (in MiB) of memory used by app"
}

variable "cpu_nginx" {
  type        = number
  description = "Number of cpu units used by nginx"
}

variable "memory_nginx" {
  type        = number
  description = "Amount (in MiB) of memory used by nginx"
}

variable "fargate_cpu" {
  type        = number
  description = "Number of cpu units used by fargate"
}

variable "fargate_memory" {
  type        = number
  description = "Amount (in MiB) of memory used by fargate"
}

variable "region" {
  type        = string
  description = "aws region"
}

variable "execution_role_arn" {
  type        = string
  description = "ARN of the task execution role that the Amazon ECS container agent and the Docker daemon can assume"
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