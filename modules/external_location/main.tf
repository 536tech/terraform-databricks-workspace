resource "databricks_external_location" "this" {
  name               = var.name
  url                = var.url
  credential_name    = var.credential_name
  isolation_mode     = var.isolation_mode
  owner              = var.owner
  read_only          = var.read_only
  fallback           = var.fallback
  enable_file_events = var.enable_file_events
  comment            = var.comment
  force_destroy      = var.force_destroy
}

resource "databricks_grants" "this" {
  count = length(var.grants) > 0 ? 1 : 0

  external_location = databricks_external_location.this.id

  dynamic "grant" {
    for_each = var.grants

    content {
      principal  = grant.value.principal
      privileges = grant.value.privileges
    }
  }
}
