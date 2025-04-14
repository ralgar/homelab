resource "openstack_identity_application_credential_v3" "designate" {
  name        = "designate"
  description = "Allows Designate API access for External DNS"
  roles       = ["member"]

  access_rules {
    path    = "/v2/**"
    service = "dns"
    method  = "POST"
  }

  access_rules {
    path    = "/v2/**"
    service = "dns"
    method  = "GET"
  }

  access_rules {
    path    = "/v2/**"
    service = "dns"
    method  = "HEAD"
  }

  access_rules {
    path    = "/v2/**"
    service = "dns"
    method  = "PATCH"
  }

  access_rules {
    path    = "/v2/**"
    service = "dns"
    method  = "PUT"
  }

  access_rules {
    path    = "/v2/**"
    service = "dns"
    method  = "DELETE"
  }
}
