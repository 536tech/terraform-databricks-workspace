# `service_principal`

One service principal.

Creates one Databricks service principal with its entitlements. Databricks generates the application id.

## Resources

- `databricks_service_principal.this`

The count-gated addresses above are part of the datatf import contract. Do not rename them.

## Usage

```hcl
module "service_principal" {
  source = "536tech/workspace/databricks//modules/service_principal"

  name                       = "etl-sp"
  allow_cluster_create       = false
  allow_instance_pool_create = false
  databricks_sql_access      = true
  workspace_access           = true
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| databricks/databricks | >= 1.128.0 |

## Inputs

| Name | Type | Description | Default | Required |
|------|------|-------------|---------|:--------:|
| `name` | `string` | Key that identifies the service principal in tfvars. Used as the display name fallback. | `n/a` | yes |
| `display_name` | `string` | Display name. Set it when the tfvars key had to be disambiguated. | `null` | no |
| `allow_cluster_create` | `bool` | Let the service principal create clusters. | `n/a` | yes |
| `allow_instance_pool_create` | `bool` | Let the service principal create instance pools. | `n/a` | yes |
| `databricks_sql_access` | `bool` | Give the service principal access to Databricks SQL. | `n/a` | yes |
| `workspace_access` | `bool` | Give the service principal access to the workspace. | `n/a` | yes |
| `workspace_consume` | `bool` | Give the service principal the consume-only entitlement. The provider rejects it together with workspace_access or databricks_sql_access, so the module sends it only when true. | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| `id` | Service principal id. |
| `application_id` | Service principal application id. |
| `display_name` | Service principal display name. |
