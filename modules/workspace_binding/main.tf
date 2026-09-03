resource "databricks_workspace_binding" "this" {
  workspace_id   = var.workspace_id
  securable_name = var.securable_name
  securable_type = var.securable_type
  binding_type   = var.binding_type
}
