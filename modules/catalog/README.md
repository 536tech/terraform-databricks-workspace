# `catalog`

One Unity Catalog catalog.

Creates one Unity Catalog catalog and, when `grants` is not empty, one `databricks_grants` block on it.

## Resources

- `databricks_catalog.this`
- `databricks_grants.this[0]` (count = 1 only when `grants` is not empty)

The count-gated addresses above are part of the datatf import contract. Do not rename them.

## Usage

```hcl
module "catalog" {
  source = "536tech/workspace/databricks//modules/catalog"

  name           = "sales"
  isolation_mode = "ISOLATED"
  owner          = "data-platform"
  comment        = "Sales domain"
  storage_root   = "abfss://sales@lake.dfs.core.windows.net/"

  grants = [{
    principal  = "data-engineers"
    privileges = ["USE_CATALOG", "USE_SCHEMA", "CREATE_SCHEMA"]
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
| [databricks_catalog.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/catalog) | resource |
| [databricks_grants.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/grants) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_comment"></a> [comment](#input\_comment) | Catalog description. | `string` | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Allow Terraform to delete the catalog while it still contains schemas. | `bool` | `false` | no |
| <a name="input_grants"></a> [grants](#input\_grants) | Direct catalog grants. A list permits computed service principal application IDs. | <pre>list(object({<br/>    principal  = string<br/>    privileges = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_isolation_mode"></a> [isolation\_mode](#input\_isolation\_mode) | Catalog isolation mode: OPEN or ISOLATED. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Catalog name. | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | Catalog owner. A user, group, or service principal. | `string` | n/a | yes |
| <a name="input_properties"></a> [properties](#input\_properties) | Catalog properties. | `map(string)` | `null` | no |
| <a name="input_storage_root"></a> [storage\_root](#input\_storage\_root) | Managed storage location for the catalog. Changing it replaces the catalog. | `string` | `null` | no |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | Catalog id. |
| <a name="output_name"></a> [name](#output\_name) | Catalog name. |
<!-- END_TF_DOCS -->
