variable "name" {
  description = "Catalog name."
  type        = string
}

variable "isolation_mode" {
  description = "Catalog isolation mode: OPEN or ISOLATED."
  type        = string
}

variable "owner" {
  description = "Catalog owner. A user, group, or service principal."
  type        = string
}

variable "comment" {
  description = "Catalog description."
  type        = string
  default     = null
}

variable "storage_root" {
  description = "Managed storage location for the catalog. Changing it replaces the catalog."
  type        = string
  default     = null
}

variable "properties" {
  description = "Catalog properties."
  type        = map(string)
  default     = null
}

variable "grants" {
  description = "Direct grants on the catalog. Shape: principal -> [privileges]."
  type        = map(list(string))
  default     = {}
}

variable "service_principal_application_ids" {
  description = "Service principal application IDs keyed by readable alias."
  type        = map(string)
  default     = {}
}

variable "force_destroy" {
  description = "Allow Terraform to delete the catalog while it still contains schemas."
  type        = bool
  default     = false
}
