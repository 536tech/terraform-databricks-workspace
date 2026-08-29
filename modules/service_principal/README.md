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

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | >= 1.128.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | >= 1.128.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [databricks_service_principal.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/service_principal) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_allow_cluster_create"></a> [allow\_cluster\_create](#input\_allow\_cluster\_create) | Let the service principal create clusters. | `bool` | n/a | yes |
| <a name="input_allow_instance_pool_create"></a> [allow\_instance\_pool\_create](#input\_allow\_instance\_pool\_create) | Let the service principal create instance pools. | `bool` | n/a | yes |
| <a name="input_databricks_sql_access"></a> [databricks\_sql\_access](#input\_databricks\_sql\_access) | Give the service principal access to Databricks SQL. | `bool` | n/a | yes |
| <a name="input_display_name"></a> [display\_name](#input\_display\_name) | Display name. Set it when the tfvars key had to be disambiguated. | `string` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Key that identifies the service principal in tfvars. Used as the display name fallback. | `string` | n/a | yes |
| <a name="input_workspace_access"></a> [workspace\_access](#input\_workspace\_access) | Give the service principal access to the workspace. | `bool` | n/a | yes |
| <a name="input_workspace_consume"></a> [workspace\_consume](#input\_workspace\_consume) | Give the service principal the consume-only entitlement. The provider rejects it together<br/>with workspace\_access or databricks\_sql\_access, so the module sends it only when true. | `bool` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_application_id"></a> [application\_id](#output\_application\_id) | Service principal application id. |
| <a name="output_display_name"></a> [display\_name](#output\_display\_name) | Service principal display name. |
| <a name="output_id"></a> [id](#output\_id) | Service principal id. |
<!-- END_TF_DOCS -->
