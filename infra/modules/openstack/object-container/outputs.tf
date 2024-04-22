output "access_key" {
  value = openstack_identity_ec2_credential_v3.swift.access
}

output "secret_key" {
  value = openstack_identity_ec2_credential_v3.swift.secret
  sensitive = true
}
