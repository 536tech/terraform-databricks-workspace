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

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | >= 1.128.0, < 2.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | >= 1.128.0, < 2.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [databricks_external_location.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/external_location) | resource |
| [databricks_grants.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/grants) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_comment"></a> [comment](#input\_comment) | External location description. | `string` | `null` | no |
| <a name="input_credential_name"></a> [credential\_name](#input\_credential\_name) | Storage credential that grants access to the URL. | `string` | n/a | yes |
| <a name="input_enable_file_events"></a> [enable\_file\_events](#input\_enable\_file\_events) | Turn on file events for the location. | `bool` | n/a | yes |
| <a name="input_fallback"></a> [fallback](#input\_fallback) | Let the workspace fall back to cluster credentials when the location has no access. | `bool` | n/a | yes |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Allow Terraform to delete the location while tables still reference it. | `bool` | `false` | no |
| <a name="input_grants"></a> [grants](#input\_grants) | Direct location grants. A list permits computed service principal application IDs. | <pre>list(object({<br/>    principal  = string<br/>    privileges = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_isolation_mode"></a> [isolation\_mode](#input\_isolation\_mode) | Isolation mode: ISOLATION\_MODE\_OPEN or ISOLATION\_MODE\_ISOLATED. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | External location name. | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | External location owner. A user, group, or service principal. | `string` | n/a | yes |
| <a name="input_read_only"></a> [read\_only](#input\_read\_only) | Limit the location to read access. | `bool` | n/a | yes |
| <a name="input_url"></a> [url](#input\_url) | Storage URL, for example abfss://container@account.dfs.core.windows.net/path. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | External location id. |
| <a name="output_name"></a> [name](#output\_name) | External location name. |
| <a name="output_url"></a> [url](#output\_url) | External location URL. |
<!-- END_TF_DOCS -->
