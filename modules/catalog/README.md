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

  grants = {
    data-engineers = ["USE_CATALOG", "USE_SCHEMA", "CREATE_SCHEMA"]
  }
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
| `name` | `string` | Catalog name. | `n/a` | yes |
| `isolation_mode` | `string` | Catalog isolation mode: OPEN or ISOLATED. | `n/a` | yes |
| `owner` | `string` | Catalog owner. A user, group, or service principal. | `n/a` | yes |
| `comment` | `string` | Catalog description. | `null` | no |
| `storage_root` | `string` | Managed storage location for the catalog. Changing it replaces the catalog. | `null` | no |
| `properties` | `map(string)` | Catalog properties. | `null` | no |
| `grants` | `map(list(string))` | Direct grants on the catalog. Shape: principal -> [privileges]. | `{}` | no |
| `force_destroy` | `bool` | Allow Terraform to delete the catalog while it still contains schemas. | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| `id` | Catalog id. |
| `name` | Catalog name. |
