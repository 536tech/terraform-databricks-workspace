<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | >= 1.128.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | >= 1.128.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [databricks_workspace_binding.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/workspace_binding) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_binding_type"></a> [binding\_type](#input\_binding\_type) | Read-only or read-write binding type. | `string` | n/a | yes |
| <a name="input_securable_name"></a> [securable\_name](#input\_securable\_name) | Unity Catalog securable name. | `string` | n/a | yes |
| <a name="input_securable_type"></a> [securable\_type](#input\_securable\_type) | Unity Catalog securable type. | `string` | n/a | yes |
| <a name="input_workspace_id"></a> [workspace\_id](#input\_workspace\_id) | Workspace ID to bind. | `number` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | Workspace binding ID. |
<!-- END_TF_DOCS -->