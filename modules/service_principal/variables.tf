variable "name" {
  description = "Key that identifies the service principal in tfvars. Used as the display name fallback."
  type        = string
}

variable "display_name" {
  description = "Display name. Set it when the tfvars key had to be disambiguated."
  type        = string
  default     = null
}

variable "allow_cluster_create" {
  description = "Let the service principal create clusters."
  type        = bool
}

variable "allow_instance_pool_create" {
  description = "Let the service principal create instance pools."
  type        = bool
}

variable "databricks_sql_access" {
  description = "Give the service principal access to Databricks SQL."
  type        = bool
}

variable "workspace_access" {
  description = "Give the service principal access to the workspace."
  type        = bool
}

variable "workspace_consume" {
  description = <<-EOT
    Give the service principal the consume-only entitlement. The provider rejects it together
    with workspace_access or databricks_sql_access, so the module sends it only when true.
  EOT

  type    = bool
  default = null
}
