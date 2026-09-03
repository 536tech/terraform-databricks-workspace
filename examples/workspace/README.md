# Workspace scope example

This root imports and then manages one workspace. It includes its Unity Catalog securables,
bindings, account identity assignments, and workspace-native objects.

The files in this directory use the DataTF fake workspace fixtures:

- `*.auto.tfvars` — one example file per input block. Terraform loads them automatically.
- `imports.tf` — one `import` block per exported object.

## The module instance name

The module instance must stay `workspace`. Every import address that datatf writes starts with
`module.workspace.`, for example:

```hcl
import {
  to = module.workspace.module.catalog["sales"].databricks_catalog.this
  id = "sales"
}
```

Rename the instance and every import address stops resolving.

## Run it

```console
export DATABRICKS_HOST=https://adb-0000.0.azuredatabricks.net
export DATABRICKS_TOKEN=...

terraform init
terraform plan -out=tfplan
terraform show tfplan
```

The plan must show imports only. If it shows a create or an update, the tfvars do not match the
live workspace; fix the tfvars before you apply.

```console
terraform apply tfplan
```

Delete `imports.tf` after the apply. Terraform ignores an import block whose resource is already
in state, but leaving the file behind hides the fact that the import is done.
