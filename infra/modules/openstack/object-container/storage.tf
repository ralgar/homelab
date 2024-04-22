resource "openstack_objectstorage_container_v1" "bucket" {
  name   = var.name

  // ACLs
  container_read  = ".r:${openstack_identity_user_v3.swift.name},.rlistings"
  container_write = "${data.openstack_identity_auth_scope_v3.current.project_id}:${openstack_identity_user_v3.swift.name}"

  force_destroy = var.environment == "prod" ? false : true
}
