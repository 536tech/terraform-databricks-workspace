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
| [databricks_permissions.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions) | resource |
| [databricks_sql_endpoint.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/sql_endpoint) | resource |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_auto_stop_mins"></a> [auto\_stop\_mins](#input\_auto\_stop\_mins) | Minutes of inactivity before the warehouse stops. 0 disables auto stop. | `number` | n/a | yes |
| <a name="input_cluster_size"></a> [cluster\_size](#input\_cluster\_size) | Warehouse size, for example 2X-Small, Small, or Medium. | `string` | n/a | yes |
| <a name="input_enable_photon"></a> [enable\_photon](#input\_enable\_photon) | Run queries on the Photon engine. | `bool` | n/a | yes |
| <a name="input_enable_serverless_compute"></a> [enable\_serverless\_compute](#input\_enable\_serverless\_compute) | Run the warehouse on serverless compute. | `bool` | n/a | yes |
| <a name="input_max_num_clusters"></a> [max\_num\_clusters](#input\_max\_num\_clusters) | Maximum number of clusters the warehouse scales to. | `number` | n/a | yes |
| <a name="input_min_num_clusters"></a> [min\_num\_clusters](#input\_min\_num\_clusters) | Minimum number of clusters the warehouse runs. | `number` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | SQL warehouse name. | `string` | n/a | yes |
| <a name="input_permissions"></a> [permissions](#input\_permissions) | Direct permissions on the warehouse. Each element names exactly one principal. | <pre>list(object({<br/>    permission_level       = string<br/>    group_name             = optional(string)<br/>    user_name              = optional(string)<br/>    service_principal_name = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_spot_instance_policy"></a> [spot\_instance\_policy](#input\_spot\_instance\_policy) | Spot policy: COST\_OPTIMIZED or RELIABILITY\_OPTIMIZED. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Custom tags applied to the warehouse. | `map(string)` | `null` | no |
| <a name="input_warehouse_type"></a> [warehouse\_type](#input\_warehouse\_type) | Warehouse type: CLASSIC or PRO. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_id"></a> [id](#output\_id) | SQL warehouse id. |
| <a name="output_jdbc_url"></a> [jdbc\_url](#output\_jdbc\_url) | JDBC URL of the warehouse. |
| <a name="output_name"></a> [name](#output\_name) | SQL warehouse name. |
<!-- END_TF_DOCS -->
