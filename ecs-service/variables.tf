variable "application" {
  type        = string
  description = "comprehensinve application name"
}

variable "cluster_name" {
  type        = string
  description = "ARN of an ECS cluster"
}


variable "task_definition_arn" {
  type        = string
  description = "full ARN of the task definition that you want to run in your service"
}

variable "desired_count" {
  type        = number
  description = "Number of instances of the task definition to place and keep running"
}

variable "target_group_arn" {
  type        = string
  description = " ARN of the Load Balancer target group to associate with the service"
}

variable "container_name" {
  type        = string
  description = " Name of the container to associate with the load balancer (as it appears in a container definition)"
}

variable "container_port" {
  type        = number
  description = "Port on the container to associate with the load balancer"
}

variable "security_groups" {
  type        = list(string)
  description = "ecurity groups associated with the task or service"
}

variable "subnets" {
  type        = list(string)
  description = "Subnets associated with the task or service"
}

variable "assign_public_ip" {
  type        = bool
  description = " Assign a public IP address to the ENI "
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