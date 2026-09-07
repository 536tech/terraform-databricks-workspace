# Adopt an existing workspace

`datatf export --scaffold` creates a Terraform root. Select this Registry release with
`--module-source 536tech/workspace/databricks --module-version 0.1.1`.
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

## Import addresses

The root module is a composition module. It reads 17 input maps and creates one child module
instance per object. The child module instance names and `for_each` keys are a contract:
[datatf](https://github.com/536tech/datatf) exports a live workspace into `terraform.tfvars` and a
matching `imports.tf`. Each import address points at a resource in the table below.
Do not rename a module instance, change a `for_each` key, or move a resource between modules
without a major version bump.

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
imports-only plan before adoption. See
[scope and validation](validation.md).

`databricks_grants.this` and `databricks_permissions.this` use `count`. The count is 1 only when
the matching access or permissions input is not empty, so the `[0]` index in an import address is
always correct when datatf emits it.

## Input behavior

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
