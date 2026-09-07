mock_provider "databricks" {}

run "policy_requires_definition_or_family" {
  command = plan

  variables {
    cluster_policies = {
      invalid = { permissions = [] }
    }
  }

  expect_failures = [var.cluster_policies]
}

run "policy_rejects_definition_and_family" {
  command = plan

  variables {
    cluster_policies = {
      invalid = {
        definition       = {}
        policy_family_id = "job-cluster"
        permissions      = []
      }
    }
  }

  expect_failures = [var.cluster_policies]
}

run "consume_rejects_workspace_access" {
  command = plan

  variables {
    service_principals = {
      invalid = {
        allow_cluster_create       = false
        allow_instance_pool_create = false
        databricks_sql_access      = false
        workspace_access           = true
        workspace_consume          = true
      }
    }
  }

  expect_failures = [var.service_principals]
}

run "consume_rejects_sql_access" {
  command = plan

  variables {
    service_principals = {
      invalid = {
        allow_cluster_create       = false
        allow_instance_pool_create = false
        databricks_sql_access      = true
        workspace_access           = false
        workspace_consume          = true
      }
    }
  }

  expect_failures = [var.service_principals]
}

run "binding_rejects_key" {
  command = plan

  variables {
    workspace_bindings = {
      "invalid" = {
        workspace_id   = 1111
        securable_name = "lake"
        securable_type = "catalog"
        binding_type   = "BINDING_TYPE_READ_WRITE"
      }
    }
  }

  expect_failures = [var.workspace_bindings]
}

run "binding_rejects_securable" {
  command = plan

  variables {
    workspace_bindings = {
      "1111|credential|lake" = {
        workspace_id   = 1111
        securable_name = "lake"
        securable_type = "credential"
        binding_type   = "BINDING_TYPE_READ_WRITE"
      }
    }
  }

  expect_failures = [var.workspace_bindings]
}

run "binding_rejects_mode" {
  command = plan

  variables {
    workspace_bindings = {
      "1111|catalog|lake" = {
        workspace_id   = 1111
        securable_name = "lake"
        securable_type = "catalog"
        binding_type   = "INVALID"
      }
    }
  }

  expect_failures = [var.workspace_bindings]
}

run "binding_rejects_read_only_storage" {
  command = plan

  variables {
    workspace_bindings = {
      "1111|storage_credential|lake" = {
        workspace_id   = 1111
        securable_name = "lake"
        securable_type = "storage_credential"
        binding_type   = "BINDING_TYPE_READ_ONLY"
      }
    }
  }

  expect_failures = [var.workspace_bindings]
}

run "binding_accepts_read_only_catalog" {
  command = plan

  variables {
    workspace_bindings = {
      "1111|catalog|lake" = {
        workspace_id   = 1111
        securable_name = "lake"
        securable_type = "catalog"
        binding_type   = "BINDING_TYPE_READ_ONLY"
      }
    }
  }
}
