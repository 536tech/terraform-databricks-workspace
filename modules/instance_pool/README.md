# `instance_pool`

One instance pool.

Creates one instance pool and, when `permissions` is not empty, one `databricks_permissions` block on it.

## Resources

- `databricks_instance_pool.this`
- `databricks_permissions.this[0]` (count = 1 only when `permissions` is not empty)

The count-gated addresses above are part of the datatf import contract. Do not rename them.

## Usage

```hcl
module "instance_pool" {
  source = "536tech/workspace/databricks//modules/instance_pool"

  name                                  = "shared-pool"
  node_type_id                          = "Standard_DS3_v2"
  min_idle_instances                    = 1
  max_capacity                          = 10
  idle_instance_autotermination_minutes = 15
  enable_elastic_disk                   = true
  preloaded_spark_versions              = ["15.4.x-scala2.12"]

  azure_attributes = {
    availability       = "ON_DEMAND_AZURE"
    spot_bid_max_price = -1
  }

  permissions = [{
    permission_level = "CAN_MANAGE"
    user_name        = "jon@example.com"
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
| `name` | `string` | Instance pool name. | `n/a` | yes |
| `node_type_id` | `string` | Azure VM size for the pool, for example Standard_DS3_v2. | `n/a` | yes |
| `min_idle_instances` | `number` | Instances the pool keeps ready. | `n/a` | yes |
| `idle_instance_autotermination_minutes` | `number` | Minutes an idle instance stays in the pool above min_idle_instances. | `n/a` | yes |
| `enable_elastic_disk` | `bool` | Add disk space to pool instances when they run low. | `n/a` | yes |
| `preloaded_spark_versions` | `list(string)` | Databricks Runtime versions cached on pool instances. | `n/a` | yes |
| `max_capacity` | `number` | Maximum number of instances in the pool. | `null` | no |
| `custom_tags` | `map(string)` | Tags applied to pool instances. | `null` | no |
| `azure_attributes` | `object({ availability = optional(string), spot_bid_max_price = optional(number) })` | Azure placement settings for pool instances. | `null` | no |
| `permissions` | `list(object({ permission_level = string, group_name = optional(string), user_name = optional(string), service_principal_name = optional(string) }))` | Direct permissions on the pool. Each element names exactly one principal. | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| `id` | Instance pool id. |
| `name` | Instance pool name. |
