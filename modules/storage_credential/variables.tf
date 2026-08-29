variable "name" {
  description = "Storage credential name."
  type        = string
}

variable "isolation_mode" {
  description = "Isolation mode: ISOLATION_MODE_OPEN or ISOLATION_MODE_ISOLATED."
  type        = string
}

variable "owner" {
  description = "Storage credential owner. A user, group, or service principal."
  type        = string
}

variable "read_only" {
  description = "Limit the credential to read access."
  type        = bool
}

variable "comment" {
  description = "Storage credential description."
  type        = string
  default     = null
}

variable "azure_managed_identity" {
  description = "Azure access connector that backs the credential."

  type = object({
    access_connector_id = string
    managed_identity_id = optional(string)
  })

  default = null
}

variable "grants" {
  description = "Direct grants on the storage credential. Shape: principal -> [privileges]."
  type        = map(list(string))
  default     = {}
}

variable "service_principal_application_ids" {
  description = "Service principal application IDs keyed by readable alias."
  type        = map(string)
  default     = {}
}

variable "force_destroy" {
  description = "Allow Terraform to delete the credential while external locations still use it."
  type        = bool
  default     = false
}
