# `schema`

One Unity Catalog schema.

Creates one schema inside an existing catalog and, when `grants` is not empty, one `databricks_grants` block on it.

## Resources

- `databricks_schema.this`
- `databricks_grants.this[0]` (count = 1 only when `grants` is not empty)

The count-gated addresses above are part of the datatf import contract. Do not rename them.

## Usage

```hcl
module "schema" {
  source = "536tech/workspace/databricks//modules/schema"

  catalog_name = "sales"
  name         = "bronze"
  comment      = "Raw landing"

  grants = [{
    principal  = "ingest@example.com"
    privileges = ["SELECT", "MODIFY"]
  }]
}
```

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
| [databricks_grants.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/grants) | resource |
| [databricks_schema.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/schema) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_catalog_name"></a> [catalog\_name](#input\_catalog\_name) | Name of the catalog that holds the schema. | `string` | n/a | yes |
| <a name="input_comment"></a> [comment](#input\_comment) | Schema description. | `string` | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Allow Terraform to delete the schema while it still contains tables. | `bool` | `false` | no |
| <a name="input_grants"></a> [grants](#input\_grants) | Direct schema grants. A list permits computed service principal application IDs. | <pre>list(object({<br/>    principal  = string<br/>    privileges = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_name"></a> [name](#input\_name) | Schema name. | `string` | n/a | yes |
| <a name="input_storage_root"></a> [storage\_root](#input\_storage\_root) | Managed storage location for the schema. Changing it replaces the schema. | `string` | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | Schema id, in the form "<catalog>.<schema>". |
| <a name="output_name"></a> [name](#output\_name) | Schema name. |
<!-- END_TF_DOCS -->
