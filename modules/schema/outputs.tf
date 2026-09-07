output "id" {
  description = "Schema id, in the form `catalog.schema`."
  value       = databricks_schema.this.id
}

output "name" {
  description = "Schema name."
  value       = databricks_schema.this.name
}
