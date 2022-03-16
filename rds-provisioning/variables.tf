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

variable "master_username" {
  type = string
  description = "Database master username"
}

variable "address" {
  type = string
  description = "The address for database"
}

variable "port" {
  type = string
  description = "The port for the database"
}