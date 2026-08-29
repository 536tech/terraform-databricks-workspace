variable "name" {
  description = "External location name."
  type        = string
}

variable "url" {
  description = "Storage URL, for example abfss://container@account.dfs.core.windows.net/path."
  type        = string
}

variable "credential_name" {
  description = "Storage credential that grants access to the URL."
  type        = string
}

variable "isolation_mode" {
  description = "Isolation mode: ISOLATION_MODE_OPEN or ISOLATION_MODE_ISOLATED."
  type        = string
}

variable "owner" {
  description = "External location owner. A user, group, or service principal."
  type        = string
}

variable "read_only" {
  description = "Limit the location to read access."
  type        = bool
}

variable "fallback" {
  description = "Let the workspace fall back to cluster credentials when the location has no access."
  type        = bool
}

variable "enable_file_events" {
  description = "Turn on file events for the location."
  type        = bool
}

variable "comment" {
  description = "External location description."
  type        = string
  default     = null
}

variable "grants" {
  description = "Direct location grants. A list permits computed service principal application IDs."
  type = list(object({
    principal  = string
    privileges = list(string)
  }))
  default = []
}

variable "force_destroy" {
  description = "Allow Terraform to delete the location while tables still reference it."
  type        = bool
  default     = false
}
