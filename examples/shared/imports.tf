# GENERATED Terraform import blocks by datatf from https://adb-1111.1.azuredatabricks.net.
# Built from the same selection as the tfvars, so imports and tfvars match.
# Keep this file in the root ONLY for the import run: terraform plan, terraform apply,
# then delete it. Grants/permissions blocks are emitted only when the matching
# access map is populated, mirroring the modules' count-gating.

import {
  to = module.workspace.module.catalog["shared_ref"].databricks_catalog.this
  id = "shared_ref"
}

import {
  to = module.workspace.module.catalog["shared_ref"].databricks_grants.this[0]
  id = "catalog/shared_ref"
}

import {
  to = module.workspace.module.schema["shared_ref.ref"].databricks_schema.this
  id = "shared_ref.ref"
}

import {
  to = module.workspace.module.storage_credential["shared_cred"].databricks_storage_credential.this
  id = "shared_cred"
}

import {
  to = module.workspace.module.workspace_binding["1111|storage_credential|shared_cred"].databricks_workspace_binding.this
  id = "1111|storage_credential|shared_cred"
}

import {
  to = module.workspace.module.workspace_binding["2222|storage_credential|shared_cred"].databricks_workspace_binding.this
  id = "2222|storage_credential|shared_cred"
}

import {
  to = module.workspace.module.storage_credential["shared_cred"].databricks_grants.this[0]
  id = "storage_credential/shared_cred"
}

import {
  to = module.workspace.module.external_location["public_ref"].databricks_external_location.this
  id = "public_ref"
}
