resource "databricks_secret_scope" "this" {
  name = var.name

  dynamic "keyvault_metadata" {
    for_each = var.keyvault_metadata == null ? [] : [var.keyvault_metadata]

    content {
      resource_id = keyvault_metadata.value.resource_id
      dns_name    = keyvault_metadata.value.dns_name
    }
  }
}

resource "databricks_secret_acl" "this" {
  for_each = var.acls == null ? {} : var.acls

  scope      = databricks_secret_scope.this.name
  principal  = each.key
  permission = each.value
}
