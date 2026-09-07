# terraform-databricks-workspace

This Terraform composition module manages the platform configuration that DataTF supports inside
an existing Azure Databricks workspace.

The root module is a composition module. It reads 17 input maps and creates one child module
instance per object. The child module instance names and `for_each` keys are a contract:
[datatf](https://github.com/536tech/datatf) exports a live workspace into `terraform.tfvars` and a
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
| `module.workspace_binding["<import-id>"]` | `databricks_workspace_binding.this` |
| `module.cluster_policy["<name>"]` | `databricks_cluster_policy.this`, `databricks_permissions.this[0]` |
| `module.instance_pool["<name>"]` | `databricks_instance_pool.this`, `databricks_permissions.this[0]` |
| `module.warehouse["<name>"]` | `databricks_sql_endpoint.this`, `databricks_permissions.this[0]` |
| `module.secret_scope["<name>"]` | `databricks_secret_scope.this`, `databricks_secret_acl.this["<principal>"]` |
| `module.service_principal["<key>"]` | `databricks_service_principal.this` |

This table is the module boundary. The module does not provision Azure resources, metastores,
account role assignments, jobs, pipelines, notebooks, models, stored data objects, or secret values.

The module supports selected platform settings, not every setting available in the provider.
DataTF reports its selected resource groups and omissions. Require a complete export and an
imports-only plan before adoption. See [scope and validation](docs/validation.md).

`databricks_grants.this` and `databricks_permissions.this` use `count`. The count is 1 only when
the matching access or permissions input is not empty, so the `[0]` index in an import address is
always correct when datatf emits it.

## Usage

Use the versioned module from the Terraform Registry:

```hcl
module "workspace" {
  source  = "536tech/workspace/databricks"
  version = "0.1.0"

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

`datatf export --scaffold` creates a Terraform root. Select this Registry release with
`--module-source 536tech/workspace/databricks --module-version 0.1.0`.
The import workflow and mock tests require Terraform 1.7 or later.
The reusable module alone requires Terraform 1.5 or later.

1. Run `datatf export --scaffold --out ./workspace` against the selected workspace.
2. Confirm that `export-report.json` is complete and covers the intended resource groups.
3. Configure a remote backend with a separate state key for this workspace.
4. Run `terraform init` in the generated root.
5. Run `terraform plan -out=tfplan`.
6. Run `terraform show tfplan`. Require imports with no creates, updates, replacements, or deletes.
7. Run `terraform apply tfplan` after approval.
8. Keep a state backup and the reviewed plan during an ownership migration.
9. Delete `imports.tf`.
10. Run `terraform plan -detailed-exitcode`. Require exit code 0.

Use one workspace state per workspace and one shared state per metastore. Both roots use a
workspace provider. Keep Azure resources, account identities, and metastore setup in a separate
bootstrap root. Never import one remote object into more than one state.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | >= 1.128.0, < 2.0.0 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_catalog"></a> [catalog](#module\_catalog) | ./modules/catalog | n/a |
| <a name="module_cluster_policy"></a> [cluster\_policy](#module\_cluster\_policy) | ./modules/cluster_policy | n/a |
| <a name="module_external_location"></a> [external\_location](#module\_external\_location) | ./modules/external_location | n/a |
| <a name="module_instance_pool"></a> [instance\_pool](#module\_instance\_pool) | ./modules/instance_pool | n/a |
| <a name="module_schema"></a> [schema](#module\_schema) | ./modules/schema | n/a |
| <a name="module_secret_scope"></a> [secret\_scope](#module\_secret\_scope) | ./modules/secret_scope | n/a |
| <a name="module_service_principal"></a> [service\_principal](#module\_service\_principal) | ./modules/service_principal | n/a |
| <a name="module_storage_credential"></a> [storage\_credential](#module\_storage\_credential) | ./modules/storage_credential | n/a |
| <a name="module_warehouse"></a> [warehouse](#module\_warehouse) | ./modules/warehouse | n/a |
| <a name="module_workspace_binding"></a> [workspace\_binding](#module\_workspace\_binding) | ./modules/workspace_binding | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_catalog_access"></a> [catalog\_access](#input\_catalog\_access) | Direct grants ON a catalog. Shape: catalog name -> principal -> [privileges].<br/>Principals: groups/users by name or email; service principals by readable alias. | `map(map(list(string)))` | `{}` | no |
| <a name="input_catalogs"></a> [catalogs](#input\_catalogs) | Catalogs to manage. Key = catalog name; value = catalog settings.<br/>A catalog must be declared here before its schemas or grants can be added. | <pre>map(object({<br/>    isolation_mode = string<br/>    owner          = string<br/>    comment        = optional(string)<br/>    storage_root   = optional(string)<br/>    properties     = optional(map(string))<br/>  }))</pre> | `{}` | no |
| <a name="input_cluster_policies"></a> [cluster\_policies](#input\_cluster\_policies) | Cluster policies. Key = policy name; value = policy settings.<br/>Set exactly one of definition or policy\_family\_id. Permissions are nested inline.<br/><br/>The type is `any` rather than `map(object(...))` on purpose: definition,<br/>policy\_family\_definition\_overrides, and libraries hold arbitrary JSON, and Terraform<br/>cannot unify two map elements whose `any` attributes have different shapes.<br/>The validation blocks below enforce the parts of the shape that are fixed.<br/><br/>Per policy:<br/>  description                        optional string<br/>  definition                         optional object, encoded to JSON by the module<br/>  policy\_family\_id                   optional string<br/>  policy\_family\_definition\_overrides optional object, encoded to JSON by the module<br/>  max\_clusters\_per\_user              optional number<br/>  libraries                          list of objects, each one of pypi, maven, cran,<br/>                                     whl, jar, egg, or requirements<br/>  permissions                        list of objects with permission\_level and exactly<br/>                                     one of group\_name, user\_name,<br/>                                     service\_principal\_name | `any` | `{}` | no |
| <a name="input_external_location_access"></a> [external\_location\_access](#input\_external\_location\_access) | Direct grants ON an external location.<br/>Shape: location name -> principal -> [privileges]. | `map(map(list(string)))` | `{}` | no |
| <a name="input_external_locations"></a> [external\_locations](#input\_external\_locations) | External locations. Key = location name; value = settings including url and credential\_name.<br/>credential\_name can reference a credential managed here or an existing shared credential. | <pre>map(object({<br/>    url                = string<br/>    credential_name    = string<br/>    isolation_mode     = string<br/>    owner              = string<br/>    read_only          = bool<br/>    fallback           = bool<br/>    enable_file_events = bool<br/>    comment            = optional(string)<br/>  }))</pre> | `{}` | no |
| <a name="input_external_service_principals"></a> [external\_service\_principals](#input\_external\_service\_principals) | Service principals managed by another Terraform root.<br/>Key = readable alias; value = Databricks application ID. | `map(string)` | `{}` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Allow Terraform to delete Unity Catalog securables that still contain objects. | `bool` | `false` | no |
| <a name="input_instance_pools"></a> [instance\_pools](#input\_instance\_pools) | Instance pools. Key = pool name; value = pool settings. | <pre>map(object({<br/>    node_type_id                          = string<br/>    min_idle_instances                    = number<br/>    idle_instance_autotermination_minutes = number<br/>    enable_elastic_disk                   = bool<br/>    preloaded_spark_versions              = list(string)<br/>    max_capacity                          = optional(number)<br/>    custom_tags                           = optional(map(string))<br/>    azure_attributes = optional(object({<br/>      availability       = optional(string)<br/>      spot_bid_max_price = optional(number)<br/>    }))<br/>    permissions = list(object({<br/>      permission_level       = string<br/>      group_name             = optional(string)<br/>      user_name              = optional(string)<br/>      service_principal_name = optional(string)<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_schema_access"></a> [schema\_access](#input\_schema\_access) | Direct grants ON a schema. Shape: catalog -> schema -> principal -> [privileges]. | `map(map(map(list(string))))` | `{}` | no |
| <a name="input_schema_comments"></a> [schema\_comments](#input\_schema\_comments) | Schema descriptions. Shape: catalog -> schema -> comment. | `map(map(string))` | `{}` | no |
| <a name="input_schema_storage_roots"></a> [schema\_storage\_roots](#input\_schema\_storage\_roots) | Custom managed storage location per schema. Shape: catalog -> schema -> URL. | `map(map(string))` | `{}` | no |
| <a name="input_schemas"></a> [schemas](#input\_schemas) | Schemas to manage. Key = catalog name; value = list of schema names in that catalog.<br/>The catalog key must also exist in `catalogs`. An empty list manages the catalog only. | `map(list(string))` | `{}` | no |
| <a name="input_secret_scopes"></a> [secret\_scopes](#input\_secret\_scopes) | Secret scopes (prefer Key Vault-backed). Key = scope name; value = settings.<br/>ACLs are nested inline under acls: principal -> permission. Do not put secret values here. | <pre>map(object({<br/>    acls = optional(map(string))<br/>    keyvault_metadata = optional(object({<br/>      resource_id = string<br/>      dns_name    = string<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_service_principals"></a> [service\_principals](#input\_service\_principals) | Service principals. Key = readable alias; value = display name and entitlements.<br/>workspace\_consume is mutually exclusive with workspace\_access and databricks\_sql\_access,<br/>so set it only when the principal has the consume-only entitlement. | <pre>map(object({<br/>    allow_cluster_create       = bool<br/>    allow_instance_pool_create = bool<br/>    databricks_sql_access      = bool<br/>    workspace_access           = bool<br/>    display_name               = optional(string)<br/>    workspace_consume          = optional(bool)<br/>  }))</pre> | `{}` | no |
| <a name="input_storage_credential_access"></a> [storage\_credential\_access](#input\_storage\_credential\_access) | Direct grants ON a storage credential.<br/>Shape: credential name -> principal -> [privileges]. | `map(map(list(string)))` | `{}` | no |
| <a name="input_storage_credentials"></a> [storage\_credentials](#input\_storage\_credentials) | Unity Catalog storage credentials. Key = credential name; value = settings<br/>(for Azure, an azure\_managed\_identity that references an existing access connector). | <pre>map(object({<br/>    isolation_mode = string<br/>    owner          = string<br/>    read_only      = bool<br/>    comment        = optional(string)<br/>    azure_managed_identity = optional(object({<br/>      access_connector_id = string<br/>      managed_identity_id = optional(string)<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_warehouses"></a> [warehouses](#input\_warehouses) | SQL warehouses. Key = warehouse name; value = warehouse settings. | <pre>map(object({<br/>    cluster_size              = string<br/>    min_num_clusters          = number<br/>    max_num_clusters          = number<br/>    auto_stop_mins            = number<br/>    warehouse_type            = string<br/>    enable_photon             = bool<br/>    enable_serverless_compute = bool<br/>    spot_instance_policy      = optional(string)<br/>    tags                      = optional(map(string))<br/>    permissions = list(object({<br/>      permission_level       = string<br/>      group_name             = optional(string)<br/>      user_name              = optional(string)<br/>      service_principal_name = optional(string)<br/>    }))<br/>  }))</pre> | `{}` | no |
| <a name="input_workspace_bindings"></a> [workspace\_bindings](#input\_workspace\_bindings) | Unity Catalog workspace bindings. The map key is the provider import ID:<br/><workspace\_id>\|<securable\_type>\|<securable\_name>. | <pre>map(object({<br/>    workspace_id   = number<br/>    securable_name = string<br/>    securable_type = string<br/>    binding_type   = string<br/>  }))</pre> | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_catalog_ids"></a> [catalog\_ids](#output\_catalog\_ids) | Managed catalogs. Key = catalog name; value = catalog id. |
| <a name="output_cluster_policy_ids"></a> [cluster\_policy\_ids](#output\_cluster\_policy\_ids) | Managed cluster policies. Key = policy name; value = policy id. |
| <a name="output_external_location_ids"></a> [external\_location\_ids](#output\_external\_location\_ids) | Managed external locations. Key = location name; value = location id. |
| <a name="output_instance_pool_ids"></a> [instance\_pool\_ids](#output\_instance\_pool\_ids) | Managed instance pools. Key = pool name; value = pool id. |
| <a name="output_schema_ids"></a> [schema\_ids](#output\_schema\_ids) | Managed schemas. Key = "<catalog>.<schema>"; value = schema id. |
| <a name="output_secret_scope_ids"></a> [secret\_scope\_ids](#output\_secret\_scope\_ids) | Managed secret scopes. Key = scope name; value = scope id. |
| <a name="output_service_principal_application_ids"></a> [service\_principal\_application\_ids](#output\_service\_principal\_application\_ids) | Managed service principals. Key = tfvars key; value = application id. |
| <a name="output_service_principal_ids"></a> [service\_principal\_ids](#output\_service\_principal\_ids) | Managed service principals. Key = tfvars key; value = service principal id. |
| <a name="output_storage_credential_ids"></a> [storage\_credential\_ids](#output\_storage\_credential\_ids) | Managed storage credentials. Key = credential name; value = credential id. |
| <a name="output_warehouse_ids"></a> [warehouse\_ids](#output\_warehouse\_ids) | Managed SQL warehouses. Key = warehouse name; value = warehouse id. |
| <a name="output_workspace_binding_ids"></a> [workspace\_binding\_ids](#output\_workspace\_binding\_ids) | Managed workspace bindings. Key = provider import ID; value = resource ID. |
<!-- END_TF_DOCS -->

## Tests

```console
terraform init -backend=false
python3 scripts/check-contract.py
```

The tests use a mock Databricks provider and current synthetic DataTF exports. The address check
compares every planned resource with DataTF's import addresses for both scopes. Tests also cover
empty inputs, absent grants, principal aliases, input rejection, and workspace binding modes.

CI uses the committed root provider lock file for every module and example. Dependabot can update
that file. CI also tests provider 1.128.0, the declared minimum. These checks require no cloud
credentials or private DataTF token. See [the validation record](docs/validation.md) for integration
checks and their limits.

## Notes on types

Configure the Databricks provider in the calling root with the target workspace URL and unified
authentication. Pass that provider to this module. Do not pass an account endpoint.

Service principals are managed through the workspace API. With identity federation, Databricks
synchronizes identities to the account. This module does not manage account role assignments or
Microsoft Entra applications. Avoid separate states that both change the same identity attributes.
See [Databricks service principal guidance](https://learn.microsoft.com/en-us/azure/databricks/dev-tools/terraform/service-principals).

`workspace_bindings` stays with the Unity Catalog securable that it restricts. A shared root can
therefore own a multi-workspace binding through one designated workspace provider.

`cluster_policies` is typed `any`, not `map(object(...))`. Its `definition`,
`policy_family_definition_overrides`, and `libraries` fields hold arbitrary JSON, and Terraform
cannot unify two map elements whose `any` attributes have different shapes. Two `validation`
blocks enforce the fixed part of the shape. Every other input carries a full object type.

`service_principals[*].workspace_consume` is optional. The provider declares `workspace_consume`
as conflicting with `workspace_access` and `databricks_sql_access`, and the conflict fires on any
value, including `false`. When `workspace_consume` is `true`, the module leaves the other two
unset. Unset means false, so the result matches the input.

Service principal keys are readable aliases. The root module resolves managed aliases from its
service principal outputs. It resolves external aliases from `external_service_principals`.
The root passes resolved grant lists and permission lists to the child modules. Names that are
not aliases pass through unchanged for users and groups.

## License

Apache-2.0. See [LICENSE](LICENSE).
