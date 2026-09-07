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
  source = "../terraform-databricks-workspace/modules/cluster_policy"

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
| [databricks_cluster_policy.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/cluster_policy) | resource |
| [databricks_permissions.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_definition"></a> [definition](#input\_definition) | Policy definition as an object. The module encodes it to JSON. | `any` | `null` | no |
| <a name="input_description"></a> [description](#input\_description) | Cluster policy description. | `string` | `null` | no |
| <a name="input_libraries"></a> [libraries](#input\_libraries) | Libraries installed on every cluster that uses the policy. Each element sets one of<br/>pypi, maven, cran, whl, jar, egg, or requirements. | `any` | `[]` | no |
| <a name="input_max_clusters_per_user"></a> [max\_clusters\_per\_user](#input\_max\_clusters\_per\_user) | Maximum number of clusters one user can start with this policy. | `number` | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | Cluster policy name. | `string` | n/a | yes |
| <a name="input_permissions"></a> [permissions](#input\_permissions) | Direct permissions on the policy. Each element names exactly one principal. | <pre>list(object({<br/>    permission_level       = string<br/>    group_name             = optional(string)<br/>    user_name              = optional(string)<br/>    service_principal_name = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_policy_family_definition_overrides"></a> [policy\_family\_definition\_overrides](#input\_policy\_family\_definition\_overrides) | Overrides on the policy family, as an object. The module encodes it to JSON. | `any` | `null` | no |
| <a name="input_policy_family_id"></a> [policy\_family\_id](#input\_policy\_family\_id) | Policy family to derive the policy from, for example job-cluster. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Cluster policy id. |
| <a name="output_name"></a> [name](#output\_name) | Cluster policy name. |
<!-- END_TF_DOCS -->
