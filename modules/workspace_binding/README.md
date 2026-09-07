# `workspace_binding`

One workspace binding for a catalog, external location, or storage credential.
The securable must use isolated access. Only catalogs support read-only bindings.
The import ID is `<workspace_id>|<securable_type>|<securable_name>`.
Keep the binding in the same state as its securable.

See the [Databricks provider documentation](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/workspace_binding).

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

- [databricks_workspace_binding.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/workspace_binding) (resource)

## Required Inputs

The following input variables are required:

### binding\_type

Description: Read-only or read-write binding type.

Type: `string`

### securable\_name

Description: Unity Catalog securable name.

Type: `string`

### securable\_type

Description: Unity Catalog securable type.

Type: `string`

### workspace\_id

Description: Workspace ID to bind.

Type: `number`

## Outputs

The following outputs are exported:

### id

Description: Workspace binding ID.
<!-- END_TF_DOCS -->