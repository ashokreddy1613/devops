variable "name" {
  description = "Prefix name for ASG resources"
  type        = string
}

variable "ami" {
  description = "AMI ID to use for instances"
  type        = string
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "key_name" {
  type        = string
  description = "Key pair for EC2 SSH access"
}

variable "security_group_id" {
  type        = string
  description = "Security group ID for ASG instances"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnets where ASG should launch EC2s"
}

variable "target_group_arns" {
  type        = list(string)
  description = "ALB Target Group ARNs"
}

variable "desired_capacity" {
  type        = number
  default     = 1
}

variable "min_size" {
  type    = number
  default = 1
}

variable "max_size" {
  type    = number
  default = 2
}

variable "tags" {
  type    = map(string)
  default = {}
}
