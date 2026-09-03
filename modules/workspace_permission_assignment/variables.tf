variable "principal_id" {
  description = "Databricks account principal ID."
  type        = number
}

variable "permissions" {
  description = "Workspace permissions for the account principal."
  type        = list(string)
}

variable "user_name" {
  description = "Optional account user name used to select the principal."
  type        = string
  default     = null
}

variable "group_name" {
  description = "Optional account group name used to select the principal."
  type        = string
  default     = null
}

variable "service_principal_name" {
  description = "Optional application ID used to select the service principal."
  type        = string
  default     = null
}

variable "service_principal_entitlements" {
  description = "Optional workspace entitlements for a service principal."

  type = object({
    allow_cluster_create       = bool
    allow_instance_pool_create = bool
    databricks_sql_access      = bool
    workspace_access           = bool
    workspace_consume          = bool
  })

  default = null
}
