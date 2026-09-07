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
  source = "../terraform-databricks-workspace/modules/instance_pool"

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
| [databricks_instance_pool.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/instance_pool) | resource |
| [databricks_permissions.this](https://registry.terraform.io/providers/databricks/databricks/latest/docs/resources/permissions) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_attributes"></a> [azure\_attributes](#input\_azure\_attributes) | Azure placement settings for pool instances. | <pre>object({<br/>    availability       = optional(string)<br/>    spot_bid_max_price = optional(number)<br/>  })</pre> | `null` | no |
| <a name="input_custom_tags"></a> [custom\_tags](#input\_custom\_tags) | Tags applied to pool instances. | `map(string)` | `null` | no |
| <a name="input_enable_elastic_disk"></a> [enable\_elastic\_disk](#input\_enable\_elastic\_disk) | Add disk space to pool instances when they run low. | `bool` | n/a | yes |
| <a name="input_idle_instance_autotermination_minutes"></a> [idle\_instance\_autotermination\_minutes](#input\_idle\_instance\_autotermination\_minutes) | Minutes an idle instance stays in the pool above min\_idle\_instances. | `number` | n/a | yes |
| <a name="input_max_capacity"></a> [max\_capacity](#input\_max\_capacity) | Maximum number of instances in the pool. | `number` | `null` | no |
| <a name="input_min_idle_instances"></a> [min\_idle\_instances](#input\_min\_idle\_instances) | Instances the pool keeps ready. | `number` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Instance pool name. | `string` | n/a | yes |
| <a name="input_node_type_id"></a> [node\_type\_id](#input\_node\_type\_id) | Azure VM size for the pool, for example Standard\_DS3\_v2. | `string` | n/a | yes |
| <a name="input_permissions"></a> [permissions](#input\_permissions) | Direct permissions on the pool. Each element names exactly one principal. | <pre>list(object({<br/>    permission_level       = string<br/>    group_name             = optional(string)<br/>    user_name              = optional(string)<br/>    service_principal_name = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_preloaded_spark_versions"></a> [preloaded\_spark\_versions](#input\_preloaded\_spark\_versions) | Databricks Runtime versions cached on pool instances. | `list(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Instance pool id. |
| <a name="output_name"></a> [name](#output\_name) | Instance pool name. |
<!-- END_TF_DOCS -->
