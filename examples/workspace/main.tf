variable "catalogs" {
  description = <<-EOT
    Catalogs to manage. Key = catalog name; value = catalog settings.
    A catalog must be declared here before its schemas or grants can be added.
  EOT

  type = map(object({
    isolation_mode = string
    owner          = string
    comment        = optional(string)
    storage_root   = optional(string)
    properties     = optional(map(string))
  }))

  default = {}
}

variable "catalog_access" {
  description = <<-EOT
    Direct grants ON a catalog. Shape: catalog name -> principal -> [privileges].
    Principals: groups/users by name or email; service principals by readable alias.
  EOT

  type    = map(map(list(string)))
  default = {}
}

variable "schemas" {
  description = <<-EOT
    Schemas to manage. Key = catalog name; value = list of schema names in that catalog.
    The catalog key must also exist in `catalogs`. An empty list manages the catalog only.
  EOT

  type    = map(list(string))
  default = {}
}

variable "schema_access" {
  description = "Direct grants ON a schema. Shape: catalog -> schema -> principal -> [privileges]."
  type        = map(map(map(list(string))))
  default     = {}
}

variable "schema_storage_roots" {
  description = "Custom managed storage location per schema. Shape: catalog -> schema -> URL."
  type        = map(map(string))
  default     = {}
}

variable "schema_comments" {
  description = "Schema descriptions. Shape: catalog -> schema -> comment."
  type        = map(map(string))
  default     = {}
}

variable "storage_credentials" {
  description = <<-EOT
    Unity Catalog storage credentials. Key = credential name; value = settings
    (for Azure, an azure_managed_identity that references an existing access connector).
  EOT

  type = map(object({
    isolation_mode = string
    owner          = string
    read_only      = bool
    comment        = optional(string)
    azure_managed_identity = optional(object({
      access_connector_id = string
      managed_identity_id = optional(string)
    }))
  }))

  default = {}
}

variable "storage_credential_access" {
  description = "Direct grants ON a storage credential. Shape: credential name -> principal -> [privileges]."
  type        = map(map(list(string)))
  default     = {}
}

variable "external_locations" {
  description = <<-EOT
    External locations. Key = location name; value = settings including url and credential_name.
    credential_name can reference a credential managed here or an existing shared credential.
  EOT

  type = map(object({
    url                = string
    credential_name    = string
    isolation_mode     = string
    owner              = string
    read_only          = bool
    fallback           = bool
    enable_file_events = bool
    comment            = optional(string)
  }))

  default = {}
}

variable "external_location_access" {
  description = "Direct grants ON an external location. Shape: location name -> principal -> [privileges]."
  type        = map(map(list(string)))
  default     = {}
}

variable "workspace_bindings" {
  type    = any
  default = {}
}

variable "cluster_policies" {
  description = <<-EOT
    Cluster policies. Key = policy name; value = policy settings.
    Set exactly one of definition or policy_family_id. Permissions are nested inline.

    The type is `any` rather than `map(object(...))` on purpose: definition,
    policy_family_definition_overrides, and libraries hold arbitrary JSON, and Terraform
    cannot unify two map elements whose `any` attributes have different shapes.
    The validation blocks below enforce the parts of the shape that are fixed.

    Per policy:
      description                        optional string
      definition                         optional object, encoded to JSON by the module
      policy_family_id                   optional string
      policy_family_definition_overrides optional object, encoded to JSON by the module
      max_clusters_per_user              optional number
      libraries                          list of objects, each one of pypi, maven, cran,
                                         whl, jar, egg, or requirements
      permissions                        list of objects with permission_level and exactly
                                         one of group_name, user_name,
                                         service_principal_name
  EOT

  type    = any
  default = {}

  validation {
    condition     = alltrue([for name, policy in var.cluster_policies : can(tolist(policy.permissions))])
    error_message = "Every cluster policy needs a permissions list. Use [] when it has none."
  }

  validation {
    condition = alltrue([
      for name, policy in var.cluster_policies :
      try(policy.definition, null) == null || try(policy.policy_family_id, null) == null
    ])
    error_message = "Set definition or policy_family_id on a cluster policy, not both."
  }
}

variable "instance_pools" {
  description = "Instance pools. Key = pool name; value = pool settings."

  type = map(object({
    node_type_id                          = string
    min_idle_instances                    = number
    idle_instance_autotermination_minutes = number
    enable_elastic_disk                   = bool
    preloaded_spark_versions              = list(string)
    max_capacity                          = optional(number)
    custom_tags                           = optional(map(string))
    azure_attributes = optional(object({
      availability       = optional(string)
      spot_bid_max_price = optional(number)
    }))
    permissions = list(object({
      permission_level       = string
      group_name             = optional(string)
      user_name              = optional(string)
      service_principal_name = optional(string)
    }))
  }))

  default = {}
}

variable "warehouses" {
  description = "SQL warehouses. Key = warehouse name; value = warehouse settings."

  type = map(object({
    cluster_size              = string
    min_num_clusters          = number
    max_num_clusters          = number
    auto_stop_mins            = number
    warehouse_type            = string
    enable_photon             = bool
    enable_serverless_compute = bool
    spot_instance_policy      = optional(string)
    tags                      = optional(map(string))
    permissions = list(object({
      permission_level       = string
      group_name             = optional(string)
      user_name              = optional(string)
      service_principal_name = optional(string)
    }))
  }))

  default = {}
}

variable "secret_scopes" {
  description = <<-EOT
    Secret scopes (prefer Key Vault-backed). Key = scope name; value = settings.
    ACLs are nested inline under acls: principal -> permission. Do not put secret values here.
  EOT

  type = map(object({
    acls = optional(map(string))
    keyvault_metadata = optional(object({
      resource_id = string
      dns_name    = string
    }))
  }))

  default = {}
}

variable "service_principals" {
  description = <<-EOT
    Service principals. Key = readable alias; value = display name and entitlements.
    workspace_consume is mutually exclusive with workspace_access and databricks_sql_access,
    so set it only when the principal has the consume-only entitlement.
  EOT

  type = map(object({
    allow_cluster_create       = bool
    allow_instance_pool_create = bool
    databricks_sql_access      = bool
    workspace_access           = bool
    display_name               = optional(string)
    workspace_consume          = optional(bool)
  }))

  default = {}
}

variable "external_service_principals" {
  description = <<-EOT
    Service principals managed by another Terraform root.
    Key = readable alias; value = Databricks application ID.
  EOT

  type    = map(string)
  default = {}
}

# Import target for the golden datatf export. The instance name must stay "workspace";
# every import address that datatf writes starts with module.workspace.
module "workspace" {
  source = "../../"

  catalogs                    = var.catalogs
  catalog_access              = var.catalog_access
  schemas                     = var.schemas
  schema_access               = var.schema_access
  schema_storage_roots        = var.schema_storage_roots
  schema_comments             = var.schema_comments
  storage_credentials         = var.storage_credentials
  storage_credential_access   = var.storage_credential_access
  external_locations          = var.external_locations
  external_location_access    = var.external_location_access
  workspace_bindings          = var.workspace_bindings
  cluster_policies            = var.cluster_policies
  instance_pools              = var.instance_pools
  warehouses                  = var.warehouses
  secret_scopes               = var.secret_scopes
  service_principals          = var.service_principals
  external_service_principals = var.external_service_principals
}
