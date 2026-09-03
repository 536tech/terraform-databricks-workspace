variable "workspace_id" {
  description = "Workspace ID to bind."
  type        = number
}

variable "securable_name" {
  description = "Unity Catalog securable name."
  type        = string
}

variable "securable_type" {
  description = "Unity Catalog securable type."
  type        = string
}

variable "binding_type" {
  description = "Read-only or read-write binding type."
  type        = string
}
