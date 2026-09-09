module "catalog" {
  source   = "536tech/catalog/databricks"
  version  = "1.0.0"
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
  source   = "536tech/schema/databricks"
  version  = "1.0.0"
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
  source   = "536tech/storage-credential/databricks"
  version  = "1.0.0"
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
  source   = "536tech/external-location/databricks"
  version  = "1.0.0"
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

module "workspace_binding" {
  source   = "536tech/workspace-binding/databricks"
  version  = "1.0.0"
  for_each = var.workspace_bindings

  workspace_id   = each.value.workspace_id
  securable_name = each.value.securable_name
  securable_type = each.value.securable_type
  binding_type   = each.value.binding_type

  depends_on = [module.catalog, module.storage_credential, module.external_location]
}

module "cluster_policy" {
  source   = "536tech/cluster-policy/databricks"
  version  = "1.0.0"
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
  source   = "536tech/instance-pool/databricks"
  version  = "1.0.0"
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
  source   = "536tech/sql-warehouse/databricks"
  version  = "1.0.0"
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
  source   = "536tech/secret-scope/databricks"
  version  = "1.0.0"
  for_each = var.secret_scopes

  name              = each.key
  acls              = each.value.acls
  keyvault_metadata = each.value.keyvault_metadata
}

module "service_principal" {
  source   = "536tech/service-principal/databricks"
  version  = "1.0.0"
  for_each = var.service_principals

  name                       = each.key
  display_name               = each.value.display_name
  allow_cluster_create       = each.value.allow_cluster_create
  allow_instance_pool_create = each.value.allow_instance_pool_create
  databricks_sql_access      = each.value.databricks_sql_access
  workspace_access           = each.value.workspace_access
  workspace_consume          = each.value.workspace_consume
}
