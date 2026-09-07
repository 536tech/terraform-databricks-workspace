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

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.5.0 |
| <a name="requirement_databricks"></a> [databricks](#requirement\_databricks) | >= 1.128.0, < 2.0.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_databricks"></a> [databricks](#provider\_databricks) | >= 1.128.0, < 2.0.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [databricks_secret_acl.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/secret_acl) | resource |
| [databricks_secret_scope.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/secret_scope) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_acls"></a> [acls](#input\_acls) | Secret ACLs. Shape: principal -> permission (READ, WRITE, or MANAGE). | `map(string)` | `null` | no |
| <a name="input_keyvault_metadata"></a> [keyvault\_metadata](#input\_keyvault\_metadata) | Azure Key Vault that backs the scope. | <pre>object({<br/>    resource_id = string<br/>    dns_name    = string<br/>  })</pre> | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Secret scope name. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | Secret scope id. |
| <a name="output_name"></a> [name](#output\_name) | Secret scope name. |
<!-- END_TF_DOCS -->
