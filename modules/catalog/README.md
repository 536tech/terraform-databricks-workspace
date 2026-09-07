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
  source = "../terraform-databricks-workspace/modules/catalog"

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

The following requirements are needed by this module:

- terraform (>= 1.5.0)

- databricks (>= 1.128.0, < 2.0.0)

## Providers

The following providers are used by this module:

- databricks (>= 1.128.0, < 2.0.0)

## Resources

The following resources are used by this module:

- [databricks_catalog.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/catalog) (resource)
- [databricks_grants.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/grants) (resource)

## Required Inputs

The following input variables are required:

### isolation\_mode

Description: Catalog isolation mode: OPEN or ISOLATED.

Type: `string`

### name

Description: Catalog name.

Type: `string`

### owner

Description: Catalog owner. A user, group, or service principal.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### comment

Description: Catalog description.

Type: `string`

Default: `null`

### force\_destroy

Description: Allow Terraform to delete the catalog while it still contains schemas.

Type: `bool`

Default: `false`

### grants

Description: Direct catalog grants. A list permits computed service principal application IDs.

Type:

```hcl
list(object({
    principal  = string
    privileges = list(string)
  }))
```

Default: `[]`

### properties

Description: Catalog properties.

Type: `map(string)`

Default: `null`

### storage\_root

Description: Managed storage location for the catalog. Changing it replaces the catalog.

Type: `string`

Default: `null`

## Outputs

The following outputs are exported:

### id

Description: Catalog id.

### name

Description: Catalog name.
<!-- END_TF_DOCS -->
