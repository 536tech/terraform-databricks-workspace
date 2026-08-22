resource "databricks_schema" "this" {
  catalog_name  = var.catalog_name
  name          = var.name
  storage_root  = var.storage_root
  comment       = var.comment
  force_destroy = var.force_destroy
}

resource "databricks_grants" "this" {
  count = length(var.grants) > 0 ? 1 : 0

  schema = databricks_schema.this.id

  dynamic "grant" {
    for_each = var.grants

    content {
      principal  = grant.key
      privileges = grant.value
    }
  }
}
