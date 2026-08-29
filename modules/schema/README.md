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

  grants = {
    "ingest@example.com" = ["SELECT", "MODIFY"]
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
| `catalog_name` | `string` | Name of the catalog that holds the schema. | `n/a` | yes |
| `name` | `string` | Schema name. | `n/a` | yes |
| `storage_root` | `string` | Managed storage location for the schema. Changing it replaces the schema. | `null` | no |
| `comment` | `string` | Schema description. | `null` | no |
| `grants` | `map(list(string))` | Direct grants on the schema. Shape: principal -> [privileges]. | `{}` | no |
| `service_principal_application_ids` | `map(string)` | Service principal application IDs keyed by readable alias. | `{}` | no |
| `force_destroy` | `bool` | Allow Terraform to delete the schema while it still contains tables. | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| `id` | Schema id, in the form "<catalog>.<schema>". |
| `name` | Schema name. |
