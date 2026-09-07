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
  source = "../terraform-databricks-workspace/modules/external_location"

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

- [databricks_external_location.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/external_location) (resource)
- [databricks_grants.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/grants) (resource)

## Required Inputs

The following input variables are required:

### credential\_name

Description: Storage credential that grants access to the URL.

Type: `string`

### enable\_file\_events

Description: Turn on file events for the location.

Type: `bool`

### fallback

Description: Let the workspace fall back to cluster credentials when the location has no access.

Type: `bool`

### isolation\_mode

Description: Isolation mode: ISOLATION\_MODE\_OPEN or ISOLATION\_MODE\_ISOLATED.

Type: `string`

### name

Description: External location name.

Type: `string`

### owner

Description: External location owner. A user, group, or service principal.

Type: `string`

### read\_only

Description: Limit the location to read access.

Type: `bool`

### url

Description: Storage URL, for example abfss://container@account.dfs.core.windows.net/path.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### comment

Description: External location description.

Type: `string`

Default: `null`

### force\_destroy

Description: Allow Terraform to delete the location while tables still reference it.

Type: `bool`

Default: `false`

### grants

Description: Direct location grants. A list permits computed service principal application IDs.

Type:

```hcl
list(object({
    principal  = string
    privileges = list(string)
  }))
```

Default: `[]`

## Outputs

The following outputs are exported:

### id

Description: External location id.

### name

Description: External location name.

### url

Description: External location URL.
<!-- END_TF_DOCS -->
