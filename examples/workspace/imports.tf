# GENERATED Terraform import blocks by datatf from https://adb-1111.1.azuredatabricks.net.
# Built from the same selection as the tfvars, so imports and tfvars match.
# Keep this file in the root ONLY for the import run: terraform plan, terraform apply,
# then delete it. Grants/permissions blocks are emitted only when the matching
# access map is populated, mirroring the modules' count-gating.

import {
  to = module.workspace.module.catalog["sales"].databricks_catalog.this
  id = "sales"
}

import {
  to = module.workspace.module.catalog["sales"].databricks_grants.this[0]
  id = "catalog/sales"
}

import {
  to = module.workspace.module.schema["sales.bronze"].databricks_schema.this
  id = "sales.bronze"
}

import {
  to = module.workspace.module.schema["sales.bronze"].databricks_grants.this[0]
  id = "schema/sales.bronze"
}

import {
  to = module.workspace.module.schema["sales.silver"].databricks_schema.this
  id = "sales.silver"
}

import {
  to = module.workspace.module.storage_credential["lake_cred"].databricks_storage_credential.this
  id = "lake_cred"
}

import {
  to = module.workspace.module.storage_credential["lake_cred"].databricks_grants.this[0]
  id = "storage_credential/lake_cred"
}

import {
  to = module.workspace.module.external_location["lake_raw"].databricks_external_location.this
  id = "lake_raw"
}

import {
  to = module.workspace.module.external_location["lake_raw"].databricks_grants.this[0]
  id = "external_location/lake_raw"
}

import {
  to = module.workspace.module.cluster_policy["Team Policy"].databricks_cluster_policy.this
  id = "P1"
}

import {
  to = module.workspace.module.cluster_policy["Team Policy"].databricks_permissions.this[0]
  id = "/cluster-policies/P1"
}

import {
  to = module.workspace.module.cluster_policy["Job Family Policy"].databricks_cluster_policy.this
  id = "P3"
}

import {
  to = module.workspace.module.cluster_policy["Job Family Policy"].databricks_permissions.this[0]
  id = "/cluster-policies/P3"
}

import {
  to = module.workspace.module.instance_pool["shared-pool"].databricks_instance_pool.this
  id = "pool-1"
}

import {
  to = module.workspace.module.instance_pool["shared-pool"].databricks_permissions.this[0]
  id = "/instance-pools/pool-1"
}

import {
  to = module.workspace.module.warehouse["Analytics WH"].databricks_sql_endpoint.this
  id = "wh1"
}

import {
  to = module.workspace.module.warehouse["Analytics WH"].databricks_permissions.this[0]
  id = "/sql/warehouses/wh1"
}

import {
  to = module.workspace.module.secret_scope["kv-scope"].databricks_secret_scope.this
  id = "kv-scope"
}

import {
  to = module.workspace.module.secret_scope["kv-scope"].databricks_secret_acl.this["admins"]
  id = "kv-scope|||admins"
}

import {
  to = module.workspace.module.secret_scope["kv-scope"].databricks_secret_acl.this["data-engineers"]
  id = "kv-scope|||data-engineers"
}

import {
  to = module.workspace.module.secret_scope["db-scope"].databricks_secret_scope.this
  id = "db-scope"
}

import {
  to = module.workspace.module.secret_scope["db-scope"].databricks_secret_acl.this["jon@example.com"]
  id = "db-scope|||jon@example.com"
}

import {
  to = module.workspace.module.service_principal["etl-sp"].databricks_service_principal.this
  id = "100"
}

import {
  to = module.workspace.module.service_principal["dup-sp (a1b2c3d4-0000-0000-0000-000000000002)"].databricks_service_principal.this
  id = "101"
}

import {
  to = module.workspace.module.service_principal["dup-sp (a1b2c3d4-0000-0000-0000-000000000003)"].databricks_service_principal.this
  id = "102"
}
