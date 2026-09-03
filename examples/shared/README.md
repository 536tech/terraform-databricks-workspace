# Shared scope example

This root manages the Unity Catalog securables that are shared: the `OPEN` ones, and the
`ISOLATED` ones that are bound to zero or many workspaces. It manages no workspace-native
objects.

There is no separate "shared" module. This example calls the same composition module as
[`examples/workspace`](../workspace) and passes only Unity Catalog inputs. Workspace-native
inputs default to `{}`. The root creates no cluster policy, instance pool, warehouse, secret
scope, or service principal.

The module instance is still named `workspace`. datatf writes `module.workspace.*` import
addresses for both scopes, so the name is fixed for the shared root too:

```hcl
import {
  to = module.workspace.module.catalog["shared_ref"].databricks_catalog.this
  id = "shared_ref"
}
```

The files in this directory use the DataTF fake workspace fixtures.

## Run it

```console
export DATABRICKS_HOST=https://adb-0000.0.azuredatabricks.net
export DATABRICKS_TOKEN=...

terraform init
terraform plan -out=tfplan
terraform show tfplan
```

The plan must show imports only.

```console
terraform apply tfplan
```

## Grants and count gating

`external_location_access` in this export is `{ public_ref = {} }`: the location is managed, and
it has no direct grants. The module gates `databricks_grants` on `length(grants) > 0`, so it
creates no grants resource, and datatf emits no import for one. The two stay in step.
