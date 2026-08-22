output "id" {
  description = "Service principal id."
  value       = databricks_service_principal.this.id
}

output "application_id" {
  description = "Service principal application id."
  value       = databricks_service_principal.this.application_id
}

output "display_name" {
  description = "Service principal display name."
  value       = databricks_service_principal.this.display_name
}
