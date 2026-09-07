# `storage_credential`

One Unity Catalog storage credential.

Creates one storage credential backed by an Azure access connector and, when `grants` is not empty, one `databricks_grants` block on it.

## Resources

- `databricks_storage_credential.this`
- `databricks_grants.this[0]` (count = 1 only when `grants` is not empty)

The count-gated addresses above are part of the datatf import contract. Do not rename them.

## Usage

```hcl
module "storage_credential" {
  source = "../terraform-databricks-workspace/modules/storage_credential"

  name           = "lake_cred"
  isolation_mode = "ISOLATION_MODE_ISOLATED"
  owner          = "data-platform"
  read_only      = false

  azure_managed_identity = {
    access_connector_id = "/subscriptions/.../accessConnectors/lake-ac"
  }

  grants = [{
    principal  = "data-platform-admins"
    privileges = ["ALL_PRIVILEGES"]
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
| [databricks_grants.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/grants) | resource |
| [databricks_storage_credential.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/storage_credential) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_managed_identity"></a> [azure\_managed\_identity](#input\_azure\_managed\_identity) | Azure access connector that backs the credential. | <pre>object({<br/>    access_connector_id = string<br/>    managed_identity_id = optional(string)<br/>  })</pre> | `null` | no |
| <a name="input_comment"></a> [comment](#input\_comment) | Storage credential description. | `string` | `null` | no |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Allow Terraform to delete the credential while external locations still use it. | `bool` | `false` | no |
| <a name="input_grants"></a> [grants](#input\_grants) | Direct credential grants. The list supports computed application IDs. | <pre>list(object({<br/>    principal  = string<br/>    privileges = list(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_isolation_mode"></a> [isolation\_mode](#input\_isolation\_mode) | Isolation mode: ISOLATION\_MODE\_OPEN or ISOLATION\_MODE\_ISOLATED. | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Storage credential name. | `string` | n/a | yes |
| <a name="input_owner"></a> [owner](#input\_owner) | Storage credential owner. A user, group, or service principal. | `string` | n/a | yes |
| <a name="input_read_only"></a> [read\_only](#input\_read\_only) | Limit the credential to read access. | `bool` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Storage credential id. |
| <a name="output_name"></a> [name](#output\_name) | Storage credential name. |
<!-- END_TF_DOCS -->
