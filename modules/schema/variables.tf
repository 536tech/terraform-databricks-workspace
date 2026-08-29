variable "catalog_name" {
  description = "Name of the catalog that holds the schema."
  type        = string
}

variable "name" {
  description = "Schema name."
  type        = string
}

variable "storage_root" {
  description = "Managed storage location for the schema. Changing it replaces the schema."
  type        = string
  default     = null
}

variable "comment" {
  description = "Schema description."
  type        = string
  default     = null
}

variable "grants" {
  description = "Direct grants on the schema. Shape: principal -> [privileges]."
  type        = map(list(string))
  default     = {}
}

variable "service_principal_application_ids" {
  description = "Service principal application IDs keyed by readable alias."
  type        = map(string)
  default     = {}
}

variable "force_destroy" {
  description = "Allow Terraform to delete the schema while it still contains tables."
  type        = bool
  default     = false
}
