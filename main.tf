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

module "catalog" {
  source   = "./modules/catalog"
  for_each = var.catalogs

  name           = each.key
  isolation_mode = each.value.isolation_mode
  owner          = each.value.owner
  comment        = each.value.comment
  storage_root   = each.value.storage_root
  properties     = each.value.properties
  grants         = lookup(local.catalog_grants, each.key, [])
  force_destroy  = var.force_destroy
}

module "schema" {
  source   = "./modules/schema"
  for_each = local.schemas

  catalog_name  = each.value.catalog_name
  name          = each.value.name
  storage_root  = each.value.storage_root
  comment       = each.value.comment
  grants        = each.value.grants
  force_destroy = var.force_destroy

  depends_on = [module.catalog]
}

module "storage_credential" {
  source   = "./modules/storage_credential"
  for_each = var.storage_credentials

  name                   = each.key
  isolation_mode         = each.value.isolation_mode
  owner                  = each.value.owner
  read_only              = each.value.read_only
  comment                = each.value.comment
  azure_managed_identity = each.value.azure_managed_identity
  grants                 = lookup(local.storage_credential_grants, each.key, [])
  force_destroy          = var.force_destroy
}

module "external_location" {
  source   = "./modules/external_location"
  for_each = var.external_locations

  name               = each.key
  url                = each.value.url
  credential_name    = each.value.credential_name
  isolation_mode     = each.value.isolation_mode
  owner              = each.value.owner
  read_only          = each.value.read_only
  fallback           = each.value.fallback
  enable_file_events = each.value.enable_file_events
  comment            = each.value.comment
  grants             = lookup(local.external_location_grants, each.key, [])
  force_destroy      = var.force_destroy

  depends_on = [module.storage_credential]
}

module "cluster_policy" {
  source   = "./modules/cluster_policy"
  for_each = var.cluster_policies

  name                               = each.key
  description                        = try(each.value.description, null)
  definition                         = try(each.value.definition, null)
  policy_family_id                   = try(each.value.policy_family_id, null)
  policy_family_definition_overrides = try(each.value.policy_family_definition_overrides, null)
  max_clusters_per_user              = try(each.value.max_clusters_per_user, null)
  libraries                          = try(each.value.libraries, [])
  permissions                        = local.cluster_policy_permissions[each.key]
}

module "instance_pool" {
  source   = "./modules/instance_pool"
  for_each = var.instance_pools

  name                                  = each.key
  node_type_id                          = each.value.node_type_id
  min_idle_instances                    = each.value.min_idle_instances
  idle_instance_autotermination_minutes = each.value.idle_instance_autotermination_minutes
  enable_elastic_disk                   = each.value.enable_elastic_disk
  preloaded_spark_versions              = each.value.preloaded_spark_versions
  max_capacity                          = each.value.max_capacity
  custom_tags                           = each.value.custom_tags
  azure_attributes                      = each.value.azure_attributes
  permissions                           = local.instance_pool_permissions[each.key]
}

module "warehouse" {
  source   = "./modules/warehouse"
  for_each = var.warehouses

  name                      = each.key
  cluster_size              = each.value.cluster_size
  min_num_clusters          = each.value.min_num_clusters
  max_num_clusters          = each.value.max_num_clusters
  auto_stop_mins            = each.value.auto_stop_mins
  warehouse_type            = each.value.warehouse_type
  enable_photon             = each.value.enable_photon
  enable_serverless_compute = each.value.enable_serverless_compute
  spot_instance_policy      = each.value.spot_instance_policy
  tags                      = each.value.tags
  permissions               = local.warehouse_permissions[each.key]
}

module "secret_scope" {
  source   = "./modules/secret_scope"
  for_each = var.secret_scopes

  name              = each.key
  acls              = each.value.acls
  keyvault_metadata = each.value.keyvault_metadata
}

module "service_principal" {
  source   = "./modules/service_principal"
  for_each = var.service_principals

  name                       = each.key
  display_name               = each.value.display_name
  allow_cluster_create       = each.value.allow_cluster_create
  allow_instance_pool_create = each.value.allow_instance_pool_create
  databricks_sql_access      = each.value.databricks_sql_access
  workspace_access           = each.value.workspace_access
  workspace_consume          = each.value.workspace_consume
}
