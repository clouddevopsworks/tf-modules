variable "application" {
  type        = string
  description = "comprehensinve application name"
}

variable "subnet_id" {
  type        = list(string)
  description = "List of subnet IDs to launch resources in"
}

variable "desired_capacity" {
  type        = number
  description = "Number of Amazon EC2 instances that should be running in the group"
}

variable "max_size" {
  type        = number
  description = "Maximum size of the Auto Scaling Group"
}

variable "min_size" {
  type        = number
  description = "Minimum size of the Auto Scaling Group"
}

variable "health_check_type" {
  type        = string
  description = "Controls how health checking is done"

}
variable "root_vol_size" {
  type        = number
  description = "The size of the volume in gigabytes"

}

variable "instance_profile" {
  type        = string
  description = "The name of the instance profile"
}

variable "image_id" {
  type        = string
  description = "The AMI from which to launch the instance"
}

variable "instance_type" {
  type        = string
  description = "The type of the instance"
}

variable "key_name" {
  type        = string
  description = "The key name to use for the instance"
}

variable "detailed_monitoring" {
  type        = bool
  description = "detailed monitoring enabled"
}

variable "associate_public_ip_address" {
  type        = bool
  description = "Associate a public ip address with the network interface"
}

variable "sg_id" {
  type        = list(string)
  description = "A list of security group names to associate with"
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