variable "name" {
  description = "Secret scope name."
  type        = string
}

variable "acls" {
  description = "Secret ACLs. Shape: principal -> permission (READ, WRITE, or MANAGE)."
  type        = map(string)
  default     = null
}

variable "keyvault_metadata" {
  description = "Azure Key Vault that backs the scope."

  type = object({
    resource_id = string
    dns_name    = string
  })

  default = null
}
