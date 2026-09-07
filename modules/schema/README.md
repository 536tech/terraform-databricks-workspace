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
  source = "../terraform-databricks-workspace/modules/schema"

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

The following requirements are needed by this module:

- terraform (>= 1.5.0)

- databricks (>= 1.128.0, < 2.0.0)

## Providers

The following providers are used by this module:

- databricks (>= 1.128.0, < 2.0.0)

## Resources

The following resources are used by this module:

- [databricks_grants.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/grants) (resource)
- [databricks_schema.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/schema) (resource)

## Required Inputs

The following input variables are required:

### catalog\_name

Description: Name of the catalog that holds the schema.

Type: `string`

### name

Description: Schema name.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### comment

Description: Schema description.

Type: `string`

Default: `null`

### force\_destroy

Description: Allow Terraform to delete the schema while it still contains tables.

Type: `bool`

Default: `false`

### grants

Description: Direct schema grants. A list permits computed service principal application IDs.

Type:

```hcl
list(object({
    principal  = string
    privileges = list(string)
  }))
```

Default: `[]`

### storage\_root

Description: Managed storage location for the schema. Changing it replaces the schema.

Type: `string`

Default: `null`

## Outputs

The following outputs are exported:

### id

Description: Schema id, in the form `catalog.schema`.

### name

Description: Schema name.
<!-- END_TF_DOCS -->
