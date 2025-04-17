# Bootstrap the deployment environment by creating a new project in OpenStack.
# If the deployment is 'admin' and the environment is 'prod' then skip, because
#  the 'admin' project exists by default in OpenStack.

resource "openstack_identity_project_v3" "this" {
  count = (var.deployment == "admin" && var.environment == "prod") ? 0 : 1
  name = var.environment == "prod" ? var.deployment : "${var.deployment}-${var.environment}"
  description = "${var.deployment} (${var.environment})"
}

data "openstack_identity_auth_scope_v3" "current" {
  count = (var.deployment == "admin" && var.environment == "prod") ? 0 : 1
  name = "current"
}

data "openstack_identity_role_v3" "admin" {
  count = (var.deployment == "admin" && var.environment == "prod") ? 0 : 1
  name = "admin"
}

resource "openstack_identity_role_assignment_v3" "this" {
  count      = (var.deployment == "admin" && var.environment == "prod") ? 0 : 1
  user_id    = data.openstack_identity_auth_scope_v3.current[0].user_id
  project_id = openstack_identity_project_v3.this[0].id
  role_id    = data.openstack_identity_role_v3.admin[0].id
}

resource "openstack_blockstorage_quotaset_v3" "this" {
  count      = (var.deployment == "admin" && var.environment == "prod") ? 0 : 1
  project_id = openstack_identity_project_v3.this[0].id
  volumes   = 25
  snapshots = 25
  backups   = 25
  gigabytes = 1000000
  per_volume_gigabytes = 1000000
  backup_gigabytes = 1000000
}
