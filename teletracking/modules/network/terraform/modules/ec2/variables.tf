variable "instances" {
  description = "List of instance configurations"
  type        = list(object({
    name             = string
    instance_type  = string
    subnet_id      = string
    volume_size    = number
    volume_type    = string
    iops           = number
    placement_group   = optional(string)
    security_groups = list(string)
  }))
  default     = []
}

variable "iam_instance_profile" {
  description = "Name of the IAM instance profile"
  type        = string
}

variable "private_ip" {
  type        = string
  description = "Private IP address to associate with the instance in the VPC"
  default     = null
}

