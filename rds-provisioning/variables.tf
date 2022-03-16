variable "name_prefix" {
  type = string
  description = "A prefix used for naming resources."
}

variable "rds_instance_id" {
  type = string
  description = "RDS instance identifier"
  default = null
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


variable "address" {
  type = string
  description = "The address for database"
  default = ""
}

variable "port" {
  type = string
  description = "The port for the database"
  default = ""
}

variable "master_username" {
  type = string
  description = "Database master username"
  default = ""
}

variable "master_password" {
  type = string
  description = "Database master password"
  default = ""
}