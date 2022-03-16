output "endpoint" {
  description = "Endpoint to RDS"
  value       = local.database_address
}

output "database" {
  description = "Name of database"
  value       = var.database
}

output "username" {
  description = "Database username"
  value       = var.username
}

output "password" {
  description = "Password for database user"
  value       = var.password
}
