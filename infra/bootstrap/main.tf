resource "openstack_identity_project_v3" "this" {
  name = "${var.deployment}-${var.environment}"
  description = "Deployment: ${var.deployment}, Environment: ${var.environment}"
}

data "openstack_identity_auth_scope_v3" "current" {
  name = "current"
}

data "openstack_identity_role_v3" "admin" {
  name = "admin"
}

resource "openstack_identity_role_assignment_v3" "this" {
  user_id    = data.openstack_identity_auth_scope_v3.current.user_id
  project_id = openstack_identity_project_v3.this.id
  role_id    = data.openstack_identity_role_v3.admin.id
}

resource "openstack_blockstorage_quotaset_v3" "this" {
  project_id = openstack_identity_project_v3.this.id
  volumes   = 25
  snapshots = 25
  backups   = 25
  gigabytes = 1000000
  per_volume_gigabytes = 1000000
  backup_gigabytes = 1000000
}
