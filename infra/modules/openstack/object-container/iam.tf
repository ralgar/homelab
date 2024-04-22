data "openstack_identity_auth_scope_v3" "current" {
  name = "current"
}

resource "openstack_identity_user_v3" "swift" {
  name        = "swiftuser-${var.name}-${var.environment}"
  description = "Service account for ${var.name} bucket (${var.environment})"
}

resource "openstack_identity_ec2_credential_v3" "swift" {
  user_id = openstack_identity_user_v3.swift.id
}

data "openstack_identity_role_v3" "member" {
  name = "swiftmember"
}

resource "openstack_identity_role_assignment_v3" "role_assignment_1" {
  user_id    = openstack_identity_user_v3.swift.id
  project_id = data.openstack_identity_auth_scope_v3.current.project_id
  role_id    = data.openstack_identity_role_v3.member.id
}
