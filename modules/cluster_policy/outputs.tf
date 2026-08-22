output "id" {
  description = "Cluster policy id."
  value       = databricks_cluster_policy.this.id
}

output "name" {
  description = "Cluster policy name."
  value       = databricks_cluster_policy.this.name
}
