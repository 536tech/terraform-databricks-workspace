resource "databricks_service_principal" "this" {
  display_name = coalesce(var.display_name, var.name)

  allow_cluster_create       = var.allow_cluster_create
  allow_instance_pool_create = var.allow_instance_pool_create

  # The provider declares workspace_consume as conflicting with workspace_access and
  # databricks_sql_access, and the conflict fires on any value, including false. When the
  # consume-only entitlement applies, leave the other two unset; unset means false.
  databricks_sql_access = var.workspace_consume == true ? null : var.databricks_sql_access
  workspace_access      = var.workspace_consume == true ? null : var.workspace_access
  workspace_consume     = var.workspace_consume == true ? true : null
}
