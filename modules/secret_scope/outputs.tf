output "id" {
  description = "Secret scope id."
  value       = databricks_secret_scope.this.id
}

output "name" {
  description = "Secret scope name."
  value       = databricks_secret_scope.this.name
}
