variable "ami" {
  description = "AMI ID"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
}

variable "security_group_id" {
  description = "Security group ID"
  type        = string
}

variable "associate_public_ip" {
  description = "Assign public IP"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags for EC2"
  type        = map(string)
  default     = {}
}
