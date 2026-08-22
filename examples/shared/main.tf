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
    Principals: groups/users by name or email; service principals by application id.
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

# The shared root is the same composition module with Unity Catalog inputs only.
# The instance name must stay "workspace"; datatf writes module.workspace.* import
# addresses for both scopes.
module "workspace" {
  source = "../../"

  catalogs                  = var.catalogs
  catalog_access            = var.catalog_access
  schemas                   = var.schemas
  schema_access             = var.schema_access
  schema_storage_roots      = var.schema_storage_roots
  schema_comments           = var.schema_comments
  storage_credentials       = var.storage_credentials
  storage_credential_access = var.storage_credential_access
  external_locations        = var.external_locations
  external_location_access  = var.external_location_access
}
