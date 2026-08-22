resource "databricks_cluster_policy" "this" {
  name                               = var.name
  description                        = var.description
  definition                         = var.definition == null ? null : jsonencode(var.definition)
  policy_family_id                   = var.policy_family_id
  policy_family_definition_overrides = var.policy_family_definition_overrides == null ? null : jsonencode(var.policy_family_definition_overrides)
  max_clusters_per_user              = var.max_clusters_per_user

  dynamic "libraries" {
    for_each = var.libraries

    content {
      whl          = try(libraries.value.whl, null)
      jar          = try(libraries.value.jar, null)
      egg          = try(libraries.value.egg, null)
      requirements = try(libraries.value.requirements, null)

      dynamic "pypi" {
        for_each = try([libraries.value.pypi], [])

        content {
          package = pypi.value.package
          repo    = try(pypi.value.repo, null)
        }
      }

      dynamic "maven" {
        for_each = try([libraries.value.maven], [])

        content {
          coordinates = maven.value.coordinates
          repo        = try(maven.value.repo, null)
          exclusions  = try(maven.value.exclusions, null)
        }
      }

      dynamic "cran" {
        for_each = try([libraries.value.cran], [])

        content {
          package = cran.value.package
          repo    = try(cran.value.repo, null)
        }
      }
    }
  }
}

resource "databricks_permissions" "this" {
  count = length(var.permissions) > 0 ? 1 : 0

  cluster_policy_id = databricks_cluster_policy.this.id

  dynamic "access_control" {
    for_each = var.permissions

    content {
      permission_level       = access_control.value.permission_level
      group_name             = access_control.value.group_name
      user_name              = access_control.value.user_name
      service_principal_name = access_control.value.service_principal_name
    }
  }
}
