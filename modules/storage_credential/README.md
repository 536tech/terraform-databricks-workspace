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

The following requirements are needed by this module:

- terraform (>= 1.5.0)

- databricks (>= 1.128.0, < 2.0.0)

## Providers

The following providers are used by this module:

- databricks (>= 1.128.0, < 2.0.0)

## Resources

The following resources are used by this module:

- [databricks_grants.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/grants) (resource)
- [databricks_storage_credential.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/storage_credential) (resource)

## Required Inputs

The following input variables are required:

### isolation\_mode

Description: Isolation mode: ISOLATION\_MODE\_OPEN or ISOLATION\_MODE\_ISOLATED.

Type: `string`

### name

Description: Storage credential name.

Type: `string`

### owner

Description: Storage credential owner. A user, group, or service principal.

Type: `string`

### read\_only

Description: Limit the credential to read access.

Type: `bool`

## Optional Inputs

The following input variables are optional (have default values):

### azure\_managed\_identity

Description: Azure access connector that backs the credential.

Type:

```hcl
object({
    access_connector_id = string
    managed_identity_id = optional(string)
  })
```

Default: `null`

### comment

Description: Storage credential description.

Type: `string`

Default: `null`

### force\_destroy

Description: Allow Terraform to delete the credential while external locations still use it.

Type: `bool`

Default: `false`

### grants

Description: Direct credential grants. The list supports computed application IDs.

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

Description: Storage credential id.

### name

Description: Storage credential name.
<!-- END_TF_DOCS -->
