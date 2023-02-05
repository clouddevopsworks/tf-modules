variable "availability_zone" {
  type        = string
  description = "An indication to identify the appliction. Passed in the Name of the resourece"
}

variable "application" {
  type        = string
  description = "An indication to identify the appliction. Passed in the Name of the resourece"
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


variable "image_id" {
  type        = string
  description = "The AMI to use for the instance. A custom image is created for the vpn server"
}

variable "subnet_id" {
  type        = string
  description = "The VPC Subnet ID to launch in"
}

variable "key_name" {
  type        = string
  description = "The key name of the Key Pair to use for the instance"
}

variable "security_groups" {
  type        = list(any)
  description = "A list of security group IDs to associate with"

}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "The type of instance to start"
}

variable "iam_instance_profile" {
  type        = string
  description = "The IAM Instance Profile to launch the instance with"
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

variable "disk_size" {
  type = list(number)

}

variable "key_file_path" {
  type = string
}
