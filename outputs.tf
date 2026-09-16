output "catalog_ids" {
  precondition {
    condition     = length(setsubtract(toset(keys(var.catalog_access)), toset(keys(var.catalogs)))) == 0
    error_message = "Every catalog_access key must name an object in catalogs."
  }

  description = "Managed catalogs. Key = catalog name; value = catalog id."
  value       = { for name, m in module.catalog : name => m.id }
}

output "schema_ids" {
  precondition {
    condition = alltrue(flatten([for catalog, schemas in var.schema_access : [
      for schema, grants in schemas : contains(try(var.schemas[catalog], []), schema)
    ]]))
    error_message = "Every schema_access target must name a schema in schemas."
  }

  description = "Managed schemas. Key = `catalog.schema`; value = schema id."
  value       = { for key, m in module.schema : key => m.id }
}

output "storage_credential_ids" {
  precondition {
    condition     = length(setsubtract(toset(keys(var.storage_credential_access)), toset(keys(var.storage_credentials)))) == 0
    error_message = "Every storage_credential_access key must name an object in storage_credentials."
  }

  description = "Managed storage credentials. Key = credential name; value = credential id."
  value       = { for name, m in module.storage_credential : name => m.id }
}

output "external_location_ids" {
  precondition {
    condition     = length(setsubtract(toset(keys(var.external_location_access)), toset(keys(var.external_locations)))) == 0
    error_message = "Every external_location_access key must name an object in external_locations."
  }

  description = "Managed external locations. Key = location name; value = location id."
  value       = { for name, m in module.external_location : name => m.id }
}

output "workspace_binding_ids" {
  description = "Managed workspace bindings. Key = provider import ID; value = resource ID."
  value       = { for key, m in module.workspace_binding : key => m.id }
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
