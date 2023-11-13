resource "google_service_account" "bucket_account" {
  account_id   = "${google_storage_bucket.default.name}-sa"
  display_name = "Bucket Service Account"
}

resource "google_service_account_key" "bucket_account" {
  service_account_id = google_service_account.bucket_account.name
}

data "google_iam_policy" "object_read_write" {
  # Read Permissions
  binding {
    role    = "roles/storage.objectAdmin"
    members = [google_service_account.bucket_account.member]
  }
}

resource "google_storage_bucket_iam_policy" "bucket_account" {
  bucket = google_storage_bucket.default.name
  policy_data = data.google_iam_policy.object_read_write.policy_data
}
