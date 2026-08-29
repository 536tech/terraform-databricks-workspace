# `external_location`

One Unity Catalog external location.

Creates one external location on top of a storage credential and, when `grants` is not empty, one `databricks_grants` block on it.

## Resources

- `databricks_external_location.this`
- `databricks_grants.this[0]` (count = 1 only when `grants` is not empty)

The count-gated addresses above are part of the datatf import contract. Do not rename them.

## Usage

```hcl
module "external_location" {
  source = "536tech/workspace/databricks//modules/external_location"

  name               = "lake_raw"
  url                = "abfss://raw@lake.dfs.core.windows.net/"
  credential_name    = "lake_cred"
  isolation_mode     = "ISOLATION_MODE_ISOLATED"
  owner              = "data-platform"
  read_only          = false
  fallback           = false
  enable_file_events = true

  grants = [{
    principal  = "data-engineers"
    privileges = ["READ_FILES", "WRITE_FILES"]
  }]
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
| `name` | `string` | External location name. | `n/a` | yes |
| `url` | `string` | Storage URL, for example abfss://container@account.dfs.core.windows.net/path. | `n/a` | yes |
| `credential_name` | `string` | Storage credential that grants access to the URL. | `n/a` | yes |
| `isolation_mode` | `string` | Isolation mode: ISOLATION_MODE_OPEN or ISOLATION_MODE_ISOLATED. | `n/a` | yes |
| `owner` | `string` | External location owner. A user, group, or service principal. | `n/a` | yes |
| `read_only` | `bool` | Limit the location to read access. | `n/a` | yes |
| `fallback` | `bool` | Let the workspace fall back to cluster credentials when the location has no access. | `n/a` | yes |
| `enable_file_events` | `bool` | Turn on file events for the location. | `n/a` | yes |
| `comment` | `string` | External location description. | `null` | no |
| `grants` | `list(object({ principal = string, privileges = list(string) }))` | Direct location grants. A list permits computed service principal application IDs. | `[]` | no |
| `force_destroy` | `bool` | Allow Terraform to delete the location while tables still reference it. | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| `id` | External location id. |
| `name` | External location name. |
| `url` | External location URL. |
