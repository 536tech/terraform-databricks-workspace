mock_provider "databricks" {}

variables {
  credential_name    = "fixture-credential"
  enable_file_events = false
  fallback           = false
  grants = [{
    principal  = "fixture-group"
    privileges = ["READ_FILES"]
  }]
  isolation_mode = "ISOLATION_MODE_ISOLATED"
  name           = "fixture-location"
  owner          = "fixture-owner"
  read_only      = false
  url            = "abfss://fixture@example.dfs.core.windows.net/"
}

run "grant_uses_stable_name" {
  command = plan

  assert {
    condition     = databricks_grants.this[0].external_location == var.name
    error_message = "The grant import target must use the known external location name."
  }
}
