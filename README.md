# terraform-databricks-workspace

Terraform modules that manage an Azure Databricks workspace: Unity Catalog securables plus the
workspace-native objects around them.

The root module is a composition module. It reads 16 input maps and creates one child module
instance per object. The child module instance names and `for_each` keys are a contract:
[datatf](https://github.com/536tech/datatf) exports a live workspace into `*.auto.tfvars` and a
matching `imports.tf`, and every import address it writes points at one of the resources listed
below. Do not rename a module instance, change a `for_each` key, or move a resource between
modules without a major version bump.

## Contract

| Module instance | Resources |
|-----------------|-----------|
| `module.catalog["<catalog>"]` | `databricks_catalog.this`, `databricks_grants.this[0]` |
| `module.schema["<catalog>.<schema>"]` | `databricks_schema.this`, `databricks_grants.this[0]` |
| `module.storage_credential["<name>"]` | `databricks_storage_credential.this`, `databricks_grants.this[0]` |
| `module.external_location["<name>"]` | `databricks_external_location.this`, `databricks_grants.this[0]` |
| `module.cluster_policy["<name>"]` | `databricks_cluster_policy.this`, `databricks_permissions.this[0]` |
| `module.instance_pool["<name>"]` | `databricks_instance_pool.this`, `databricks_permissions.this[0]` |
| `module.warehouse["<name>"]` | `databricks_sql_endpoint.this`, `databricks_permissions.this[0]` |
| `module.secret_scope["<name>"]` | `databricks_secret_scope.this`, `databricks_secret_acl.this["<principal>"]` |
| `module.service_principal["<key>"]` | `databricks_service_principal.this` |

`databricks_grants.this` and `databricks_permissions.this` use `count`. The count is 1 only when
the matching access or permissions input is not empty, so the `[0]` index in an import address is
always correct when datatf emits it.

## Usage

```hcl
module "workspace" {
  source  = "536tech/workspace/databricks"
  version = "~> 0.1"

  catalogs = {
    sales = {
      isolation_mode = "ISOLATED"
      owner          = "data-platform"
      comment        = "Sales domain"
      storage_root   = "abfss://sales@lake.dfs.core.windows.net/"
    }
  }

  catalog_access = {
    sales = {
      data-engineers = ["USE_CATALOG", "USE_SCHEMA", "CREATE_SCHEMA"]
    }
  }

  schemas = {
    sales = ["bronze", "silver"]
  }
}
```

Every input defaults to `{}`, so a Unity Catalog only root works with the Unity Catalog inputs
alone. See [`examples/shared`](examples/shared).

## Import a live workspace

1. Run `datatf export` against the workspace. It writes `*.auto.tfvars` and `imports.tf`.
2. Copy both into a root that calls this module with the instance name `workspace`.
3. Run `terraform plan`. The plan must show imports only.
4. Run `terraform apply`.
5. Delete `imports.tf`.

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| databricks/databricks | >= 1.128.0, < 2.0.0 |

The provider is workspace level. Configure it with `DATABRICKS_HOST` and a token, or with
`DATABRICKS_CONFIG_PROFILE`. This repository has no account-level provider and manages no
account-level objects.

## Modules

| Name | Purpose |
|------|---------|
| [`catalog`](modules/catalog) | One Unity Catalog catalog and its grants |
| [`schema`](modules/schema) | One schema and its grants |
| [`storage_credential`](modules/storage_credential) | One storage credential and its grants |
| [`external_location`](modules/external_location) | One external location and its grants |
| [`cluster_policy`](modules/cluster_policy) | One cluster policy and its permissions |
| [`instance_pool`](modules/instance_pool) | One instance pool and its permissions |
| [`warehouse`](modules/warehouse) | One SQL warehouse and its permissions |
| [`secret_scope`](modules/secret_scope) | One secret scope and its ACLs |
| [`service_principal`](modules/service_principal) | One service principal and its entitlements |

## Tests

```console
terraform init -backend=false
terraform test
```

`tests/contract.tftest.hcl` mocks the Databricks provider and plans the datatf golden workspace
export. It asserts the module instance count for every kind, so a change that breaks an import
address fails the test.

## Notes on types

`cluster_policies` is typed `any`, not `map(object(...))`. Its `definition`,
`policy_family_definition_overrides`, and `libraries` fields hold arbitrary JSON, and Terraform
cannot unify two map elements whose `any` attributes have different shapes. Two `validation`
blocks enforce the fixed part of the shape. Every other input carries a full object type.

`service_principals[*].workspace_consume` is optional. The provider declares `workspace_consume`
as conflicting with `workspace_access` and `databricks_sql_access`, and the conflict fires on any
value, including `false`. When `workspace_consume` is `true`, the module leaves the other two
unset. Unset means false, so the result matches the input.

Service principal keys are readable aliases. The module resolves managed aliases from the
created service principals. It resolves external aliases from `external_service_principals`.
The module passes names that are not aliases through unchanged for users and groups.

## License

Apache-2.0. See [LICENSE](LICENSE).

## Inputs

| Name | Type | Description | Default | Required |
|------|------|-------------|---------|:--------:|
| `catalogs` | `map(object({ isolation_mode = string, owner = string, comment = optional(string), storage_root = optional(string), properties = optional(map(string)) }))` | Catalogs to manage. Key = catalog name; value = catalog settings. A catalog must be declared here before its schemas or grants can be added. | `{}` | no |
| `catalog_access` | `map(map(list(string)))` | Direct grants ON a catalog. Shape: catalog name -> principal -> [privileges]. Principals: groups/users by name or email; service principals by readable alias. | `{}` | no |
| `schemas` | `map(list(string))` | Schemas to manage. Key = catalog name; value = list of schema names in that catalog. The catalog key must also exist in `catalogs`. An empty list manages the catalog only. | `{}` | no |
| `schema_access` | `map(map(map(list(string))))` | Direct grants ON a schema. Shape: catalog -> schema -> principal -> [privileges]. | `{}` | no |
| `schema_storage_roots` | `map(map(string))` | Custom managed storage location per schema. Shape: catalog -> schema -> URL. | `{}` | no |
| `schema_comments` | `map(map(string))` | Schema descriptions. Shape: catalog -> schema -> comment. | `{}` | no |
| `storage_credentials` | `map(object({ isolation_mode = string, owner = string, read_only = bool, comment = optional(string), azure_managed_identity = optional(object({ access_connector_id = string, managed_identity_id = optional(string) })) }))` | Unity Catalog storage credentials. Key = credential name; value = settings (for Azure, an azure_managed_identity that references an existing access connector). | `{}` | no |
| `storage_credential_access` | `map(map(list(string)))` | Direct grants ON a storage credential. Shape: credential name -> principal -> [privileges]. | `{}` | no |
| `external_locations` | `map(object({ url = string, credential_name = string, isolation_mode = string, owner = string, read_only = bool, fallback = bool, enable_file_events = bool, comment = optional(string) }))` | External locations. Key = location name; value = settings including url and credential_name. credential_name can reference a credential managed here or an existing shared credential. | `{}` | no |
| `external_location_access` | `map(map(list(string)))` | Direct grants ON an external location. Shape: location name -> principal -> [privileges]. | `{}` | no |
| `cluster_policies` | `any` | Cluster policies. Key = policy name; value = policy settings. Set exactly one of definition or policy_family_id. Permissions are nested inline. See `variables.tf` for the full shape and the reason the type is `any`. | `{}` | no |
| `instance_pools` | `map(object({ node_type_id = string, min_idle_instances = number, idle_instance_autotermination_minutes = number, enable_elastic_disk = bool, preloaded_spark_versions = list(string), max_capacity = optional(number), custom_tags = optional(map(string)), azure_attributes = optional(object({ availability = optional(string), spot_bid_max_price = optional(number) })), permissions = list(object({ permission_level = string, group_name = optional(string), user_name = optional(string), service_principal_name = optional(string) })) }))` | Instance pools. Key = pool name; value = pool settings. | `{}` | no |
| `warehouses` | `map(object({ cluster_size = string, min_num_clusters = number, max_num_clusters = number, auto_stop_mins = number, warehouse_type = string, enable_photon = bool, enable_serverless_compute = bool, spot_instance_policy = optional(string), tags = optional(map(string)), permissions = list(object({ permission_level = string, group_name = optional(string), user_name = optional(string), service_principal_name = optional(string) })) }))` | SQL warehouses. Key = warehouse name; value = warehouse settings. | `{}` | no |
| `secret_scopes` | `map(object({ acls = optional(map(string)), keyvault_metadata = optional(object({ resource_id = string, dns_name = string })) }))` | Secret scopes (prefer Key Vault-backed). Key = scope name; value = settings. ACLs are nested inline under acls: principal -> permission. Do not put secret values here. | `{}` | no |
| `service_principals` | `map(object({ allow_cluster_create = bool, allow_instance_pool_create = bool, databricks_sql_access = bool, workspace_access = bool, display_name = optional(string), workspace_consume = optional(bool) }))` | Service principals. Key = readable alias; value = display name and entitlements. workspace_consume is mutually exclusive with workspace_access and databricks_sql_access, so set it only when the principal has the consume-only entitlement. | `{}` | no |
| `external_service_principals` | `map(string)` | Service principals managed by another Terraform root. Key = readable alias; value = Databricks application ID. | `{}` | no |
| `force_destroy` | `bool` | Allow Terraform to delete Unity Catalog securables that still contain objects. | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| `catalog_ids` | Managed catalogs. Key = catalog name; value = catalog id. |
| `schema_ids` | Managed schemas. Key = "<catalog>.<schema>"; value = schema id. |
| `storage_credential_ids` | Managed storage credentials. Key = credential name; value = credential id. |
| `external_location_ids` | Managed external locations. Key = location name; value = location id. |
| `cluster_policy_ids` | Managed cluster policies. Key = policy name; value = policy id. |
| `instance_pool_ids` | Managed instance pools. Key = pool name; value = pool id. |
| `warehouse_ids` | Managed SQL warehouses. Key = warehouse name; value = warehouse id. |
| `secret_scope_ids` | Managed secret scopes. Key = scope name; value = scope id. |
| `service_principal_ids` | Managed service principals. Key = tfvars key; value = service principal id. |
| `service_principal_application_ids` | Managed service principals. Key = tfvars key; value = application id. |
