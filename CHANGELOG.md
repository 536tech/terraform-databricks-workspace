# Changelog

All notable changes to this project are recorded in this file.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.1.0/), and this project
uses [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

Module instance names, `for_each` keys, and the count-gated `[0]` indexes are part of the public
interface, because datatf import addresses point at them. A change to any of them is a breaking
change.

## [Unreleased]

### Added

- Root composition module with 15 inputs: `catalogs`, `catalog_access`, `schemas`,
  `schema_access`, `schema_storage_roots`, `schema_comments`, `storage_credentials`,
  `storage_credential_access`, `external_locations`, `external_location_access`,
  `cluster_policies`, `instance_pools`, `warehouses`, `secret_scopes`, `service_principals`.
- Submodules `catalog`, `schema`, `storage_credential`, `external_location`, `cluster_policy`,
  `instance_pool`, `warehouse`, `secret_scope`, and `service_principal`.
- Examples `examples/workspace` and `examples/shared`, each with the matching datatf golden
  export and its `imports.tf`.
- `tests/contract.tftest.hcl`, a mocked-provider plan over the golden workspace export.
