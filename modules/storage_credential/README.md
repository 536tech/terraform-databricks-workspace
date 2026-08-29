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
  source = "536tech/workspace/databricks//modules/storage_credential"

  name           = "lake_cred"
  isolation_mode = "ISOLATION_MODE_ISOLATED"
  owner          = "data-platform"
  read_only      = false

  azure_managed_identity = {
    access_connector_id = "/subscriptions/.../accessConnectors/lake-ac"
  }

  grants = {
    data-platform-admins = ["ALL_PRIVILEGES"]
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
| `name` | `string` | Storage credential name. | `n/a` | yes |
| `isolation_mode` | `string` | Isolation mode: ISOLATION_MODE_OPEN or ISOLATION_MODE_ISOLATED. | `n/a` | yes |
| `owner` | `string` | Storage credential owner. A user, group, or service principal. | `n/a` | yes |
| `read_only` | `bool` | Limit the credential to read access. | `n/a` | yes |
| `comment` | `string` | Storage credential description. | `null` | no |
| `azure_managed_identity` | `object({ access_connector_id = string, managed_identity_id = optional(string) })` | Azure access connector that backs the credential. | `null` | no |
| `grants` | `map(list(string))` | Direct grants on the storage credential. Shape: principal -> [privileges]. | `{}` | no |
| `force_destroy` | `bool` | Allow Terraform to delete the credential while external locations still use it. | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| `id` | Storage credential id. |
| `name` | Storage credential name. |
