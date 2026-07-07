variable "aws_region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_username" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "instance_class" {
  type = string
}

variable "backup_retention_period" {
  type = number
}

variable "deletion_protection" {
  type = bool
}

variable "db_engine" {
  type = string
}

variable "db_engine_version" {
  type = string
}

variable "db_port" {
  type = number
}