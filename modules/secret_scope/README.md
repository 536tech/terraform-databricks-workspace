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
  source = "../terraform-databricks-workspace/modules/secret_scope"

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

The following requirements are needed by this module:

- terraform (>= 1.5.0)

- databricks (>= 1.128.0, < 2.0.0)

## Providers

The following providers are used by this module:

- databricks (>= 1.128.0, < 2.0.0)

## Resources

The following resources are used by this module:

- [databricks_secret_acl.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/secret_acl) (resource)
- [databricks_secret_scope.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/secret_scope) (resource)

## Required Inputs

The following input variables are required:

### name

Description: Secret scope name.

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### acls

Description: Secret ACLs. Shape: principal -> permission (READ, WRITE, or MANAGE).

Type: `map(string)`

Default: `null`

### keyvault\_metadata

Description: Azure Key Vault that backs the scope.

Type:

```hcl
object({
    resource_id = string
    dns_name    = string
  })
```

Default: `null`

## Outputs

The following outputs are exported:

### id

Description: Secret scope id.

### name

Description: Secret scope name.
<!-- END_TF_DOCS -->
