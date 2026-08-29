mock_provider "databricks" {}

run "catalog_grant_resolves_alias" {
  command = plan

  module {
    source = "./modules/catalog"
  }

  variables {
    name           = "sales"
    isolation_mode = "ISOLATED"
    owner          = "data-platform"
    grants = {
      external-etl-sp = ["USE_CATALOG"]
    }
    service_principal_application_ids = {
      external-etl-sp = "a1b2c3d4-0000-0000-0000-000000000001"
    }
  }

  assert {
    condition = contains([
      for grant in databricks_grants.this[0].grant : grant.principal
    ], "a1b2c3d4-0000-0000-0000-000000000001")
    error_message = "The catalog grant must use the service principal application ID."
  }
}

run "cluster_policy_permission_resolves_alias" {
  command = plan

  module {
    source = "./modules/cluster_policy"
  }

  variables {
    name = "Job Policy"
    definition = {
      spark_version = {
        type  = "fixed"
        value = "15.4.x-scala2.12"
      }
    }
    permissions = [{
      permission_level       = "CAN_USE"
      service_principal_name = "external-etl-sp"
    }]
    service_principal_application_ids = {
      external-etl-sp = "a1b2c3d4-0000-0000-0000-000000000001"
    }
  }

  assert {
    condition = contains([
      for access in databricks_permissions.this[0].access_control : access.service_principal_name
    ], "a1b2c3d4-0000-0000-0000-000000000001")
    error_message = "The policy permission must use the service principal application ID."
  }
}
