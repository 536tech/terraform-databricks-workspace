# Contract test. The values below are the datatf golden workspace export
# (internal/contract/testdata/golden/workspace). They must stay in step with it:
# the import blocks datatf writes address exactly the module instances asserted here.

mock_provider "databricks" {}

variables {
  catalogs = {
    sales = {
      comment        = "Sales domain"
      isolation_mode = "ISOLATED"
      owner          = "data-platform"
      properties = {
        team = "sales"
      }
      storage_root = "abfss://sales@lake.dfs.core.windows.net/"
    }
  }

  catalog_access = {
    sales = {
      data-engineers  = ["CREATE_SCHEMA", "USE_CATALOG", "USE_SCHEMA"]
      external-etl-sp = ["SELECT", "USE_CATALOG", "USE_SCHEMA"]
    }
  }

  external_service_principals = {
    external-etl-sp = "a1b2c3d4-0000-0000-0000-000000000001"
  }

  schemas = {
    sales = ["bronze", "silver"]
  }

  schema_access = {
    sales = {
      bronze = {
        "ingest@example.com" = ["MODIFY", "SELECT"]
      }
      silver = {}
    }
  }

  schema_storage_roots = {
    sales = {
      bronze = "abfss://sales@lake.dfs.core.windows.net/bronze"
    }
  }

  schema_comments = {
    sales = {
      bronze = "Raw landing"
    }
  }

  storage_credentials = {
    lake_cred = {
      azure_managed_identity = {
        access_connector_id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.Databricks/accessConnectors/lake-ac"
        managed_identity_id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.ManagedIdentity/userAssignedIdentities/lake-mi"
      }
      comment        = "Lake access connector"
      isolation_mode = "ISOLATION_MODE_ISOLATED"
      owner          = "data-platform"
      read_only      = false
    }
  }

  storage_credential_access = {
    lake_cred = {
      data-platform-admins = ["ALL_PRIVILEGES"]
    }
  }

  external_locations = {
    lake_raw = {
      comment            = "Raw zone"
      credential_name    = "lake_cred"
      enable_file_events = true
      fallback           = false
      isolation_mode     = "ISOLATION_MODE_ISOLATED"
      owner              = "data-platform"
      read_only          = false
      url                = "abfss://raw@lake.dfs.core.windows.net/"
    }
  }

  external_location_access = {
    lake_raw = {
      etl-sp = ["READ_FILES", "WRITE_FILES"]
    }
  }

  cluster_policies = {
    "Job Family Policy" = {
      libraries = []
      permissions = [{
        permission_level       = "CAN_USE"
        service_principal_name = "external-etl-sp"
      }]
      policy_family_definition_overrides = {
        "custom_tags.team" = {
          type  = "fixed"
          value = "data"
        }
      }
      policy_family_id = "job-cluster"
    }
    "Team Policy" = {
      definition = {
        autotermination_minutes = {
          defaultValue = 30
          maxValue     = 60
          type         = "range"
        }
        spark_version = {
          type  = "fixed"
          value = "15.4.x-scala2.12"
        }
      }
      description = "Pinned runtime for team clusters"
      libraries = [{
        pypi = {
          package = "great-expectations==0.18.0"
        }
      }]
      max_clusters_per_user = 2
      permissions = [{
        group_name       = "data-engineers"
        permission_level = "CAN_USE"
      }]
    }
  }

  instance_pools = {
    shared-pool = {
      azure_attributes = {
        availability       = "ON_DEMAND_AZURE"
        spot_bid_max_price = -1
      }
      custom_tags = {
        cost_center = "1234"
      }
      enable_elastic_disk                   = true
      idle_instance_autotermination_minutes = 15
      max_capacity                          = 10
      min_idle_instances                    = 1
      node_type_id                          = "Standard_DS3_v2"
      permissions = [{
        permission_level = "CAN_MANAGE"
        user_name        = "jon@example.com"
      }]
      preloaded_spark_versions = ["15.4.x-scala2.12"]
    }
  }

  warehouses = {
    "Analytics WH" = {
      auto_stop_mins            = 20
      cluster_size              = "Small"
      enable_photon             = true
      enable_serverless_compute = true
      max_num_clusters          = 3
      min_num_clusters          = 1
      permissions = [{
        group_name       = "analysts"
        permission_level = "CAN_USE"
      }]
      spot_instance_policy = "COST_OPTIMIZED"
      tags = {
        team = "analytics"
      }
      warehouse_type = "PRO"
    }
  }

  secret_scopes = {
    db-scope = {
      acls = {
        "jon@example.com" = "MANAGE"
      }
    }
    kv-scope = {
      acls = {
        admins         = "MANAGE"
        data-engineers = "READ"
      }
      keyvault_metadata = {
        dns_name    = "https://kv-data.vault.azure.net/"
        resource_id = "/subscriptions/sub/resourceGroups/rg/providers/Microsoft.KeyVault/vaults/kv-data"
      }
    }
  }

  service_principals = {
    dup-sp-1 = {
      allow_cluster_create       = false
      allow_instance_pool_create = false
      databricks_sql_access      = false
      display_name               = "dup-sp"
      workspace_access           = false
    }
    dup-sp-2 = {
      allow_cluster_create       = true
      allow_instance_pool_create = false
      databricks_sql_access      = false
      display_name               = "dup-sp"
      workspace_access           = false
      workspace_consume          = true
    }
    etl-sp = {
      allow_cluster_create       = false
      allow_instance_pool_create = false
      databricks_sql_access      = true
      workspace_access           = true
    }
  }
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
    condition     = length(module.cluster_policy) == 2
    error_message = "Expected 2 cluster policy module instances."
  }

  assert {
    condition     = sort(keys(module.cluster_policy)) == tolist(["Job Family Policy", "Team Policy"])
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

  assert {
    condition = contains([
      for grant in local.catalog_grants["sales"] : grant.principal
    ], "a1b2c3d4-0000-0000-0000-000000000001")
    error_message = "Catalog grants must resolve an external service principal alias."
  }

  assert {
    condition = contains([
      for permission in local.cluster_policy_permissions["Job Family Policy"] :
      permission.service_principal_name
    ], "a1b2c3d4-0000-0000-0000-000000000001")
    error_message = "Policy permissions must resolve an external service principal alias."
  }
}

run "unity_catalog_only_export" {
  command = plan

  variables {
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
    condition     = length(module.instance_pool) == 0 && length(module.warehouse) == 0 && length(module.secret_scope) == 0 && length(module.service_principal) == 0
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
