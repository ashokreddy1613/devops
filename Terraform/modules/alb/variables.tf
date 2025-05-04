variable "name" {
  type        = string
  description = "ALB name"
}

variable "vpc_id" {
  type = string
}

variable "subnet_ids" {
  type        = list(string)
  description = "Public subnet IDs for ALB"
}

variable "security_group_id" {
  type        = string
  description = "ALB security group"
}

variable "target_instance_ids" {
  type        = list(string)
  description = "List of EC2 instance IDs to attach"
}

variable "target_port" {
  type        = number
  default     = 80
}

variable "tags" {
  type    = map(string)
  default = {}
}
