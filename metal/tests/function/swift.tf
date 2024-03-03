resource "openstack_objectstorage_container_v1" "test" {
  name   = "test-container-1"

  metadata = {
    test = "true"
  }

  content_type = "application/json"
  versioning   = false
}

resource "openstack_objectstorage_object_v1" "json_test" {
  name           = "test/default.json"
  container_name = openstack_objectstorage_container_v1.test.name
  content_type   = "application/json"

  metadata = {
    test = "true"
  }

  content = jsonencode({
    foo = "bar"
  })
}
