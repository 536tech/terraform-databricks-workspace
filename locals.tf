locals {
  service_principal_ids = merge(
    var.external_service_principals,
    { for alias, principal in module.service_principal : alias => principal.application_id }
  )

  catalog_grants = {
    for catalog, grants in var.catalog_access : catalog => [
      for principal, privileges in grants : {
        principal  = lookup(local.service_principal_ids, principal, principal)
        privileges = privileges
      }
    ]
  }

  # Flatten catalog -> [schema] into one map keyed "<catalog>.<schema>", which is
  # the address datatf emits in its import blocks.
  schemas = merge([
    for catalog, names in var.schemas : {
      for name in names : "${catalog}.${name}" => {
        catalog_name = catalog
        name         = name
        storage_root = try(var.schema_storage_roots[catalog][name], null)
        comment      = try(var.schema_comments[catalog][name], null)
        grants = [
          for principal, privileges in try(var.schema_access[catalog][name], {}) : {
            principal  = lookup(local.service_principal_ids, principal, principal)
            privileges = privileges
          }
        ]
      }
    }
  ]...)

  storage_credential_grants = {
    for credential, grants in var.storage_credential_access : credential => [
      for principal, privileges in grants : {
        principal  = lookup(local.service_principal_ids, principal, principal)
        privileges = privileges
      }
    ]
  }

  external_location_grants = {
    for location, grants in var.external_location_access : location => [
      for principal, privileges in grants : {
        principal  = lookup(local.service_principal_ids, principal, principal)
        privileges = privileges
      }
    ]
  }

  cluster_policy_permissions = {
    for name, policy in var.cluster_policies : name => [
      for permission in policy.permissions : merge(permission, {
        service_principal_name = (
          try(permission.service_principal_name, null) == null
          ? null
          : lookup(
            local.service_principal_ids,
            permission.service_principal_name,
            permission.service_principal_name
          )
        )
      })
    ]
  }

  instance_pool_permissions = {
    for name, pool in var.instance_pools : name => [
      for permission in pool.permissions : merge(permission, {
        service_principal_name = (
          permission.service_principal_name == null
          ? null
          : lookup(
            local.service_principal_ids,
            permission.service_principal_name,
            permission.service_principal_name
          )
        )
      })
    ]
  }

  warehouse_permissions = {
    for name, warehouse in var.warehouses : name => [
      for permission in warehouse.permissions : merge(permission, {
        service_principal_name = (
          permission.service_principal_name == null
          ? null
          : lookup(
            local.service_principal_ids,
            permission.service_principal_name,
            permission.service_principal_name
          )
        )
      })
    ]
  }
}
