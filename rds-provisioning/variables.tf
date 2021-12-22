variable "name_prefix" {
  type = string
  description = "A prefix used for naming resources."
}

variable "rds_instance_id" {
  type = string
  description = "RDS instance identifier"
}

variable "database" {
  type = string
  description = "Name of database"
}

variable "username" {
  type = string
  description = "Database username"
}

variable "password" {
  type = string
  description = "Password for database user"
}
