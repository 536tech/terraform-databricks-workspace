variable "name" {
  description = "Cluster policy name."
  type        = string
}

variable "description" {
  description = "Cluster policy description."
  type        = string
  default     = null
}

variable "definition" {
  description = "Policy definition as an object. The module encodes it to JSON."
  type        = any
  default     = null
}

variable "policy_family_id" {
  description = "Policy family to derive the policy from, for example job-cluster."
  type        = string
  default     = null
}

variable "policy_family_definition_overrides" {
  description = "Overrides on the policy family, as an object. The module encodes it to JSON."
  type        = any
  default     = null
}

variable "max_clusters_per_user" {
  description = "Maximum number of clusters one user can start with this policy."
  type        = number
  default     = null
}

variable "libraries" {
  description = <<-EOT
    Libraries installed on every cluster that uses the policy. Each element sets one of
    pypi, maven, cran, whl, jar, egg, or requirements.
  EOT

  # `any`, not list(any): Terraform unifies list element types, and a pypi entry and a
  # maven entry have different shapes.
  type    = any
  default = []
}

variable "permissions" {
  description = "Direct permissions on the policy. Each element names exactly one principal."

  type = list(object({
    permission_level       = string
    group_name             = optional(string)
    user_name              = optional(string)
    service_principal_name = optional(string)
  }))

  default = []
}

variable "service_principal_application_ids" {
  description = "Service principal application IDs keyed by readable alias."
  type        = map(string)
  default     = {}
}
