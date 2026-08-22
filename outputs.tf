output "catalog_ids" {
  description = "Managed catalogs. Key = catalog name; value = catalog id."
  value       = { for name, m in module.catalog : name => m.id }
}

output "schema_ids" {
  description = "Managed schemas. Key = \"<catalog>.<schema>\"; value = schema id."
  value       = { for key, m in module.schema : key => m.id }
}

output "storage_credential_ids" {
  description = "Managed storage credentials. Key = credential name; value = credential id."
  value       = { for name, m in module.storage_credential : name => m.id }
}

output "external_location_ids" {
  description = "Managed external locations. Key = location name; value = location id."
  value       = { for name, m in module.external_location : name => m.id }
}

output "cluster_policy_ids" {
  description = "Managed cluster policies. Key = policy name; value = policy id."
  value       = { for name, m in module.cluster_policy : name => m.id }
}

output "instance_pool_ids" {
  description = "Managed instance pools. Key = pool name; value = pool id."
  value       = { for name, m in module.instance_pool : name => m.id }
}

output "warehouse_ids" {
  description = "Managed SQL warehouses. Key = warehouse name; value = warehouse id."
  value       = { for name, m in module.warehouse : name => m.id }
}

output "secret_scope_ids" {
  description = "Managed secret scopes. Key = scope name; value = scope id."
  value       = { for name, m in module.secret_scope : name => m.id }
}

output "service_principal_ids" {
  description = "Managed service principals. Key = tfvars key; value = service principal id."
  value       = { for key, m in module.service_principal : key => m.id }
}

output "service_principal_application_ids" {
  description = "Managed service principals. Key = tfvars key; value = application id."
  value       = { for key, m in module.service_principal : key => m.application_id }
}
