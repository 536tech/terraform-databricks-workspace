# `secret_scope`

One secret scope.

Creates one secret scope, optionally backed by Azure Key Vault, and one `databricks_secret_acl` per entry in `acls`. The module never holds secret values.

## Resources

- `databricks_secret_scope.this`
- `databricks_secret_acl.this["<principal>"]` (one per entry in `acls`)

The count-gated addresses above are part of the datatf import contract. Do not rename them.

## Usage

```hcl
module "secret_scope" {
  source = "536tech/workspace/databricks//modules/secret_scope"

  name = "kv-scope"

  keyvault_metadata = {
    resource_id = "/subscriptions/.../vaults/kv-data"
    dns_name    = "https://kv-data.vault.azure.net/"
  }

  acls = {
    admins         = "MANAGE"
    data-engineers = "READ"
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
| `name` | `string` | Secret scope name. | `n/a` | yes |
| `acls` | `map(string)` | Secret ACLs. Shape: principal -> permission (READ, WRITE, or MANAGE). | `null` | no |
| `keyvault_metadata` | `object({ resource_id = string, dns_name = string })` | Azure Key Vault that backs the scope. | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| `id` | Secret scope id. |
| `name` | Secret scope name. |
