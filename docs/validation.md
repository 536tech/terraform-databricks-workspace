# Scope and validation

This module composes selected platform settings inside an existing Azure Databricks workspace.
It uses ten independently released child modules and thirteen Terraform resource types.
DataTF exports inputs and imports for those resources.
It does not export every Databricks object or every provider attribute.

## State ownership

| Root | Ownership | Provider |
| --- | --- | --- |
| Workspace | Workspace configuration and isolated UC objects bound only to that workspace | That workspace endpoint |
| Shared | Open UC objects and isolated objects bound to zero or multiple workspaces | One designated workspace endpoint |
| Bootstrap, outside this module | Azure resources, metastore setup, account identities and assignments | Azure and account providers as required |

`shared` is a DataTF ownership category. It is not a Databricks resource type or Delta Sharing.
Databricks catalogs belong to a metastore. Workspace bindings restrict access to them.
Use one shared state per metastore. Do not repeat shared imports in each workspace state.
See [workspace-catalog binding][bindings] and [Azure Unity Catalog setup][uc].

Bindings stay with their securables. Catalogs use `ISOLATED`; storage credentials and external
locations use `ISOLATION_MODE_ISOLATED`. Only catalogs support read-only bindings.
Terraform can automatically bind a newly created isolated securable to the current workspace.
Review that implicit binding when you create resources. See [the binding resource][binding-resource].

## Boundaries that affect adoption

- Configure a workspace provider in the calling root. The module contains no provider configuration.
- Workspace service principals can synchronize to the account when identity federation is enabled.
  Their identity attributes are not necessarily exclusive to one workspace. Use a single owner for
  shared identity attributes. See [Databricks identity guidance][identity].
- `databricks_grants` controls all direct grants on its securable. `databricks_permissions` controls
  the object's permission set. Do not split one set across Terraform states. See [grants][grants]
  and [permissions][permissions].
- Empty grant or permission inputs omit the corresponding resource. They do not express an
  authoritative empty permission set. Secret ACLs use one resource per principal.
- Schema ownership, schema properties, service principal activation, and other omitted attributes
  are outside the current input contract. A complete DataTF report does not prove that an arbitrary
  workspace can be imported without changes. The reviewed plan must prove that.
- `force_destroy` defaults to false. Enabling it permits deletion of populated UC securables.
  It is not an adoption requirement.
- Jobs, pipelines, notebooks, tables, volumes, secret values, cloud resources, and metastore setup
  stay outside this module. Use separate roots or workload deployment tools for those lifecycles.

The module is suitable for the supported platform subset of a workspace. A second shared module
is not required. Separate roots and states express ownership without changing DataTF addresses.

## Repeatable checks

PR checks run without Azure credentials, Databricks credentials, or a private repository token.
They apply equally to human and Dependabot PRs under a read-only GitHub token.

```sh
terraform fmt -recursive -check
terraform init -backend=false -lockfile=readonly
terraform validate
python3 scripts/check-contract.py
tflint --recursive
actionlint
zizmor .github/workflows/ci.yml
```

CI copies the committed root provider lock to each example before validation.
Each resource repository validates its own module and runs its own mock tests.
Dependabot monitors Terraform, GitHub Actions, and pre-commit updates weekly, in groups, with a
seven-day cooldown. Terraform lock updates select the tested provider without raising the module's
minimum version for each release. See [Dependabot options][dependabot].

The tests use the real provider schema with mocked provider operations. They check both DataTF
fixture exports, every resource address, empty inputs, absent grants, alias resolution, invalid
policy definitions, conflicting entitlements, and binding validation. They do not prove remote API
behavior. CI tests the locked provider and the minimum supported provider, 1.128.0.

Run the producer-consumer integration check from a current DataTF checkout:

```sh
make check
scripts/e2e-fake.sh /absolute/path/to/terraform-databricks-workspace
```

This uses the real provider against DataTF's fake API. Require imports only in both scopes.
Use the separate infra-private Azure lifecycle for cloud authentication, actual API behavior,
import apply, post-import drift checks, repeat exports, and cleanup verification.

## Resource module extraction: 2026-09-07

Workspace pattern `0.2.0` pins all ten Registry resource modules at `0.1.0`.
The published Terraform files match the bundled resource implementations in workspace `0.1.1`.
The pattern preserves its inputs, outputs, child module names, keys, and resource addresses.

All ten resource repositories pass CI with the locked provider, 1.130.0, and the minimum, 1.128.0.
The pattern passes all 15 contract tests and validates both examples with Registry dependencies.
DataTF CI tests the complete public Registry chain with the real provider against its fake API.
It imports 27 workspace resources and 8 shared resources, then obtains clean second plans.
A separate Terraform 1.15.6 check upgrades existing `0.1.1` states to Registry version `0.2.0`.
Both scopes retain the same tfvars and resource addresses. Both upgrade plans return exit code 0.

[Azure run 34169326942][extraction-run] uses infra-private commit
`b028f685440e8c3f6532ebd19663aa2b5e65c1cd`, Terraform 1.16.1, and Databricks provider 1.131.0
for the exported roots. The bootstrap uses provider 1.129.0.
The run checks module commit `1ede900cd4fc13a3f11dc546af3f862460e2cd66`, whose contents match
workspace release `0.2.0` at `90423817d0de5cc1092f6ab800d4bcbb36b7ca4d`.
It checks DataTF commit `0861626cb92d91be5cada0735245439271c23062`.
The DataTF application sources match merged commit `204dc51decb6f035d2c7b1bae6a434e01a46dc7e`.
The later packaging change does not alter the export code.

| Scope | Imports | Export report | Plan after import |
| --- | ---: | --- | --- |
| Workspace | 49 | Complete | No changes |
| Shared | 5 | Complete | No changes |

The import plans cover all thirteen supported resource types. They contain zero creates, updates,
replacements, or deletes. The workflow applies the saved import plans and removes the import blocks.
Both subsequent plans return exit code 0. Repeat exports match.
Cleanup removes all 79 bootstrap fixtures. The Azure cleanup check passes, and the E2E state is empty.
The run uses a local pattern checkout that downloads the released Registry resource modules.
The separate DataTF CI and upgrade checks also download the pattern itself from the Registry.

## Audit evidence: 2026-09-06

The checked DataTF commit is `2958f18f24c46a42ec3478e370dc0c7c046dc5f1`.
The module baseline is `ff329393753c8e91b1c94f572ca6e559bd6950d6`.
PR 2 preserves its resource definitions and addresses. Its input guards reject invalid policy
and entitlement combinations; they do not alter valid exported resource settings.

[Azure run 34063680888][cloud-run] uses infra-private commit
`d96673b71c16032cb7616215d52038e4a1f254fb`, Terraform 1.16.0, and Databricks provider 1.130.0
for the exported roots. The bootstrap uses provider 1.129.0. Both exports report complete with
no read issues. The import plans contain all thirteen resource types in the DataTF matrix.

| Terraform resource type | Workspace imports | Shared imports |
| --- | ---: | ---: |
| `databricks_catalog` | 3 | 1 |
| `databricks_schema` | 4 | 1 |
| `databricks_storage_credential` | 3 | 1 |
| `databricks_external_location` | 3 | 1 |
| `databricks_workspace_binding` | 9 | 0 |
| `databricks_grants` | 7 | 1 |
| `databricks_cluster_policy` | 2 | 0 |
| `databricks_instance_pool` | 1 | 0 |
| `databricks_sql_endpoint` | 2 | 0 |
| `databricks_permissions` | 5 | 0 |
| `databricks_secret_scope` | 2 | 0 |
| `databricks_secret_acl` | 4 | 0 |
| `databricks_service_principal` | 4 | 0 |
| **Total** | **49** | **5** |

Both plans contain imports with zero creates, updates, replacements, or deletes. The workflow
applies them, removes the import blocks, and obtains exit code 0 from each subsequent plan.
Repeat exports match. Cleanup removes all 79 bootstrap fixtures and leaves an empty E2E state.

The cloud result covers the baseline, not a new execution of PR 2. It does not cover every possible
attribute combination. The local fake API check covers multi-workspace bindings in the shared
scope; this cloud run's shared scope contains no bindings. Production adoption still requires
its own complete export, reviewed import-only plan, and state backup.

[bindings]: https://learn.microsoft.com/en-us/azure/databricks/data-governance/unity-catalog/access-control/workspace-catalog-binding
[uc]: https://github.com/databricks/terraform-provider-databricks/blob/v1.130.0/docs/guides/unity-catalog-azure.md
[binding-resource]: https://github.com/databricks/terraform-provider-databricks/blob/v1.130.0/docs/resources/workspace_binding.md
[identity]: https://learn.microsoft.com/en-us/azure/databricks/dev-tools/terraform/service-principals
[grants]: https://github.com/databricks/terraform-provider-databricks/blob/v1.130.0/docs/resources/grants.md
[permissions]: https://github.com/databricks/terraform-provider-databricks/blob/v1.130.0/docs/resources/permissions.md
[dependabot]: https://docs.github.com/en/code-security/reference/supply-chain-security/dependabot-options-reference
[cloud-run]: https://github.com/536tech/infra-private/actions/runs/34063680888
[extraction-run]: https://github.com/536tech/infra-private/actions/runs/34169326942
