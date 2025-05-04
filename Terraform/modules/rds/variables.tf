variable "name" {}
variable "engine" {
  default = "postgres"
}
variable "instance_class" {
  default = "db.t3.micro"
}
variable "allocated_storage" {
  default = 20
}
variable "username" {}
variable "password" {}
variable "db_name" {}
variable "subnet_ids" {
  type = list(string)
}
variable "security_group_id" {}
variable "skip_final_snapshot" {
  default = true
}
variable "multi_az" {
  default = false
}
variable "storage_encrypted" {
  default = true
}
variable "backup_retention_period" {
  default = 7
}
variable "tags" {
  default = {}
}
