output "name" {
  value = google_storage_bucket.default.name
}

output "service_account_key" {
  value = google_service_account_key.bucket_account.private_key
}
