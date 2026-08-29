# `cluster_policy`

One cluster policy.

Creates one cluster policy and, when `permissions` is not empty, one `databricks_permissions` block on it. The module encodes `definition` and `policy_family_definition_overrides` to JSON, so pass them as objects.

## Resources

- `databricks_cluster_policy.this`
- `databricks_permissions.this[0]` (count = 1 only when `permissions` is not empty)

The count-gated addresses above are part of the datatf import contract. Do not rename them.

## Usage

```hcl
module "cluster_policy" {
  source = "536tech/workspace/databricks//modules/cluster_policy"

  name        = "Team Policy"
  description = "Pinned runtime for team clusters"

  definition = {
    spark_version = {
      type  = "fixed"
      value = "15.4.x-scala2.12"
    }
  }

  libraries = [{
    pypi = {
      package = "great-expectations==0.18.0"
    }
  }]

  permissions = [{
    permission_level = "CAN_USE"
    group_name       = "data-engineers"
  }]
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
| `name` | `string` | Cluster policy name. | `n/a` | yes |
| `description` | `string` | Cluster policy description. | `null` | no |
| `definition` | `any` | Policy definition as an object. The module encodes it to JSON. | `null` | no |
| `policy_family_id` | `string` | Policy family to derive the policy from, for example job-cluster. | `null` | no |
| `policy_family_definition_overrides` | `any` | Overrides on the policy family, as an object. The module encodes it to JSON. | `null` | no |
| `max_clusters_per_user` | `number` | Maximum number of clusters one user can start with this policy. | `null` | no |
| `libraries` | `any` | Libraries installed on every cluster that uses the policy. Each element sets one of pypi, maven, cran, whl, jar, egg, or requirements. | `[]` | no |
| `permissions` | `list(object({ permission_level = string, group_name = optional(string), user_name = optional(string), service_principal_name = optional(string) }))` | Direct permissions on the policy. Each element names exactly one principal. | `[]` | no |
| `service_principal_application_ids` | `map(string)` | Service principal application IDs keyed by readable alias. | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| `id` | Cluster policy id. |
| `name` | Cluster policy name. |
