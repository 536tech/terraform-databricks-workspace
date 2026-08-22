output "id" {
  description = "External location id."
  value       = databricks_external_location.this.id
}

output "name" {
  description = "External location name."
  value       = databricks_external_location.this.name
}

output "url" {
  description = "External location URL."
  value       = databricks_external_location.this.url
}
