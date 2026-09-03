resource "databricks_permission_assignment" "this" {
  principal_id = (
    var.user_name == null && var.group_name == null && var.service_principal_name == null
    ? var.principal_id
    : null
  )
  user_name              = var.user_name
  group_name             = var.group_name
  service_principal_name = var.service_principal_name
  permissions            = var.permissions
}

resource "databricks_entitlements" "this" {
  count = var.service_principal_entitlements == null ? 0 : 1

  service_principal_id       = var.principal_id
  allow_cluster_create       = var.service_principal_entitlements.allow_cluster_create
  allow_instance_pool_create = var.service_principal_entitlements.allow_instance_pool_create
  databricks_sql_access = (
    var.service_principal_entitlements.workspace_consume
    ? null
    : var.service_principal_entitlements.databricks_sql_access
  )
  workspace_access = (
    var.service_principal_entitlements.workspace_consume
    ? null
    : var.service_principal_entitlements.workspace_access
  )
  workspace_consume = var.service_principal_entitlements.workspace_consume ? true : null

  depends_on = [databricks_permission_assignment.this]
}
