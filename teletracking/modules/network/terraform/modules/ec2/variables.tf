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
