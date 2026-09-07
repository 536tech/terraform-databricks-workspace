# DataTF golden fixtures: see tests/fixtures/README.md.

mock_provider "databricks" {}

variables {
  catalogs = jsondecode(file("tests/fixtures/workspace.json")).tfvars.catalogs
  catalog_access = (
    jsondecode(file("tests/fixtures/workspace.json")).tfvars.catalog_access
  )
  schemas       = jsondecode(file("tests/fixtures/workspace.json")).tfvars.schemas
  schema_access = jsondecode(file("tests/fixtures/workspace.json")).tfvars.schema_access
  schema_storage_roots = (
    jsondecode(file("tests/fixtures/workspace.json")).tfvars.schema_storage_roots
  )
  schema_comments = (
    jsondecode(file("tests/fixtures/workspace.json")).tfvars.schema_comments
  )
  storage_credentials = (
    jsondecode(file("tests/fixtures/workspace.json")).tfvars.storage_credentials
  )
  storage_credential_access = (
    jsondecode(file("tests/fixtures/workspace.json")).tfvars.storage_credential_access
  )
  external_locations = (
    jsondecode(file("tests/fixtures/workspace.json")).tfvars.external_locations
  )
  external_location_access = (
    jsondecode(file("tests/fixtures/workspace.json")).tfvars.external_location_access
  )
  workspace_bindings = (
    jsondecode(file("tests/fixtures/workspace.json")).tfvars.workspace_bindings
  )
  cluster_policies = (
    jsondecode(file("tests/fixtures/workspace.json")).tfvars.cluster_policies
  )
  instance_pools = (
    jsondecode(file("tests/fixtures/workspace.json")).tfvars.instance_pools
  )
  warehouses    = jsondecode(file("tests/fixtures/workspace.json")).tfvars.warehouses
  secret_scopes = jsondecode(file("tests/fixtures/workspace.json")).tfvars.secret_scopes
  service_principals = (
    jsondecode(file("tests/fixtures/workspace.json")).tfvars.service_principals
  )
}

run "golden_workspace_export" {
  command = plan

  assert {
    condition     = length(module.catalog) == 1
    error_message = "Expected 1 catalog module instance."
  }

  assert {
    condition     = length(module.schema) == 2
    error_message = "Expected 2 schema module instances."
  }

  assert {
    condition     = sort(keys(module.schema)) == tolist(["sales.bronze", "sales.silver"])
    error_message = "Schema module keys must be \"<catalog>.<schema>\"."
  }

  assert {
    condition     = length(module.storage_credential) == 1
    error_message = "Expected 1 storage credential module instance."
  }

  assert {
    condition     = length(module.external_location) == 1
    error_message = "Expected 1 external location module instance."
  }

  assert {
    condition     = length(module.workspace_binding) == 3
    error_message = "Expected 3 workspace binding module instances."
  }

  assert {
    condition     = length(module.cluster_policy) == 2
    error_message = "Expected 2 cluster policy module instances."
  }

  assert {
    condition = sort(keys(module.cluster_policy)) == tolist([
      "Job Family Policy",
      "Team Policy",
    ])
    error_message = "Cluster policy module keys must be the policy names."
  }

  assert {
    condition     = length(module.instance_pool) == 1
    error_message = "Expected 1 instance pool module instance."
  }

  assert {
    condition     = length(module.warehouse) == 1
    error_message = "Expected 1 warehouse module instance."
  }

  assert {
    condition     = length(module.secret_scope) == 2
    error_message = "Expected 2 secret scope module instances."
  }

  assert {
    condition     = length(module.service_principal) == 3
    error_message = "Expected 3 service principal module instances."
  }

  assert {
    condition     = length(output.service_principal_ids) == 3
    error_message = "Every service principal must be exposed in service_principal_ids."
  }
}

run "golden_shared_export" {
  command = plan

  variables {
    catalogs       = jsondecode(file("tests/fixtures/shared.json")).tfvars.catalogs
    catalog_access = jsondecode(file("tests/fixtures/shared.json")).tfvars.catalog_access
    schemas        = jsondecode(file("tests/fixtures/shared.json")).tfvars.schemas
    schema_access  = jsondecode(file("tests/fixtures/shared.json")).tfvars.schema_access
    schema_storage_roots = (
      jsondecode(file("tests/fixtures/shared.json")).tfvars.schema_storage_roots
    )
    schema_comments = (
      jsondecode(file("tests/fixtures/shared.json")).tfvars.schema_comments
    )
    storage_credentials = (
      jsondecode(file("tests/fixtures/shared.json")).tfvars.storage_credentials
    )
    storage_credential_access = (
      jsondecode(file("tests/fixtures/shared.json")).tfvars.storage_credential_access
    )
    external_locations = (
      jsondecode(file("tests/fixtures/shared.json")).tfvars.external_locations
    )
    external_location_access = (
      jsondecode(file("tests/fixtures/shared.json")).tfvars.external_location_access
    )
    workspace_bindings = (
      jsondecode(file("tests/fixtures/shared.json")).tfvars.workspace_bindings
    )
    cluster_policies   = {}
    instance_pools     = {}
    warehouses         = {}
    secret_scopes      = {}
    service_principals = {}
  }

  assert {
    condition     = length(module.catalog) == 1
    error_message = "The shared scope must still manage its catalogs."
  }

  assert {
    condition     = length(module.cluster_policy) == 0
    error_message = "A Unity Catalog only export must create no workspace-native modules."
  }

  assert {
    condition = (
      length(module.instance_pool) == 0 &&
      length(module.warehouse) == 0 &&
      length(module.secret_scope) == 0 &&
      length(module.service_principal) == 0
    )
    error_message = "A Unity Catalog only export must create no workspace-native modules."
  }
}

run "no_inputs" {
  command = plan

  variables {
    catalogs                    = {}
    catalog_access              = {}
    schemas                     = {}
    schema_access               = {}
    schema_storage_roots        = {}
    schema_comments             = {}
    storage_credentials         = {}
    storage_credential_access   = {}
    external_locations          = {}
    external_location_access    = {}
    external_service_principals = {}
    cluster_policies            = {}
    instance_pools              = {}
    warehouses                  = {}
    secret_scopes               = {}
    service_principals          = {}
    workspace_bindings          = {}
  }

  assert {
    condition     = length(module.catalog) == 0 && length(module.schema) == 0
    error_message = "An empty input set must create nothing."
  }
}

run "securable_without_grants" {
  command = plan

  variables {
    catalogs = {
      granted = {
        isolation_mode = "ISOLATED"
        owner          = "data-platform"
      }
      ungranted = {
        isolation_mode = "ISOLATED"
        owner          = "data-platform"
      }
    }

    catalog_access = {
      granted = {
        data-engineers = ["USE_CATALOG"]
      }
    }

    schemas = {
      granted = ["bronze"]
    }

    schema_access             = {}
    schema_storage_roots      = {}
    schema_comments           = {}
    storage_credentials       = {}
    storage_credential_access = {}
    external_locations        = {}
    external_location_access  = {}
    cluster_policies          = {}
    instance_pools            = {}
    warehouses                = {}
    secret_scopes             = {}
    service_principals        = {}
    workspace_bindings        = {}
  }

  assert {
    condition     = length(module.catalog) == 2
    error_message = "A catalog with no entry in catalog_access must still be managed."
  }

  assert {
    condition     = length(module.schema) == 1
    error_message = "A schema with no entry in schema_access must still be managed."
  }
}

run "invalid_workspace_binding" {
  command = plan

  variables {
    workspace_bindings = {
      invalid = {
        binding_type   = "BINDING_TYPE_READ_ONLY"
        securable_name = "lake_cred"
        securable_type = "storage_credential"
        workspace_id   = 1111
      }
    }
  }

  expect_failures = [var.workspace_bindings]
}

run "principal_aliases" {
  command = apply

  variables {
    external_service_principals = {
      external-etl = "a1b2c3d4-0000-0000-0000-000000000099"
    }
    catalog_access = {
      sales = {
        external-etl = ["USE_CATALOG"]
        etl-sp       = ["USE_CATALOG"]
      }
    }
    cluster_policies = {
      Alias = {
        definition = {}
        permissions = [
          { permission_level = "CAN_USE", service_principal_name = "external-etl" },
          { permission_level = "CAN_USE", service_principal_name = "etl-sp" },
        ]
      }
    }
  }

  assert {
    condition = toset([for grant in local.catalog_grants.sales : grant.principal]) == toset([
      "a1b2c3d4-0000-0000-0000-000000000099",
      output.service_principal_application_ids["etl-sp"],
    ])
    error_message = "Catalog grants must resolve managed and external application IDs."
  }

  assert {
    condition = toset([
      for permission in local.cluster_policy_permissions.Alias : permission.service_principal_name
      ]) == toset([
      "a1b2c3d4-0000-0000-0000-000000000099",
      output.service_principal_application_ids["etl-sp"],
    ])
    error_message = "Policy permissions must resolve managed and external application IDs."
  }
}
