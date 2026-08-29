# `warehouse`

One SQL warehouse.

Creates one SQL warehouse and, when `permissions` is not empty, one `databricks_permissions` block on it. The module turns the `tags` map into `tags { custom_tags { ... } }` blocks.

## Resources

- `databricks_sql_endpoint.this`
- `databricks_permissions.this[0]` (count = 1 only when `permissions` is not empty)

The count-gated addresses above are part of the datatf import contract. Do not rename them.

## Usage

```hcl
module "warehouse" {
  source = "536tech/workspace/databricks//modules/warehouse"

  name                      = "Analytics WH"
  cluster_size              = "Small"
  min_num_clusters          = 1
  max_num_clusters          = 3
  auto_stop_mins            = 20
  warehouse_type            = "PRO"
  enable_photon             = true
  enable_serverless_compute = true

  tags = {
    team = "analytics"
  }

  permissions = [{
    permission_level = "CAN_USE"
    group_name       = "analysts"
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
| `name` | `string` | SQL warehouse name. | `n/a` | yes |
| `cluster_size` | `string` | Warehouse size, for example 2X-Small, Small, or Medium. | `n/a` | yes |
| `min_num_clusters` | `number` | Minimum number of clusters the warehouse runs. | `n/a` | yes |
| `max_num_clusters` | `number` | Maximum number of clusters the warehouse scales to. | `n/a` | yes |
| `auto_stop_mins` | `number` | Minutes of inactivity before the warehouse stops. 0 disables auto stop. | `n/a` | yes |
| `warehouse_type` | `string` | Warehouse type: CLASSIC or PRO. | `n/a` | yes |
| `enable_photon` | `bool` | Run queries on the Photon engine. | `n/a` | yes |
| `enable_serverless_compute` | `bool` | Run the warehouse on serverless compute. | `n/a` | yes |
| `spot_instance_policy` | `string` | Spot policy: COST_OPTIMIZED or RELIABILITY_OPTIMIZED. | `null` | no |
| `tags` | `map(string)` | Custom tags applied to the warehouse. | `null` | no |
| `permissions` | `list(object({ permission_level = string, group_name = optional(string), user_name = optional(string), service_principal_name = optional(string) }))` | Direct permissions on the warehouse. Each element names exactly one principal. | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| `id` | SQL warehouse id. |
| `name` | SQL warehouse name. |
| `jdbc_url` | JDBC URL of the warehouse. |
