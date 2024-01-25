resource "random_string" "bucket_id" {
  length  = 8
  numeric = true
  lower   = true
  upper   = false
  special = false
}

resource "google_storage_bucket" "default" {
  name          = "${var.name_prefix}-${random_string.bucket_id.result}"
  location      = "US-WEST1"  # Free tier must use US-WEST1, US-CENTRAL1, or US-EAST1
  storage_class = "REGIONAL"  # Free tier must use REGIONAL storage class

  # When destroying a bucket, destroy all contained objects.
  force_destroy = true

  # Ensure no public access
  public_access_prevention = "enforced"

  uniform_bucket_level_access = true

  # versioning {
  #   enabled = true
  # }

  # Keep objects for 7 days
  # lifecycle_rule {
  #   condition {
  #     age = 7  # 7 days
  #   }
  #   action {
  #     type = "Delete"
  #   }
  # }
}
