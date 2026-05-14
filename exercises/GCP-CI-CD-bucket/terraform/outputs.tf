output "bucket_name" {
  description = "Name of the GCS bucket"
  value       = google_storage_bucket.website.name
}

output "bucket_url" {
  description = "Storage API URL for the bucket"
  value       = "https://storage.googleapis.com/${google_storage_bucket.website.name}"
}

output "website_url" {
  description = "Public URL to access the static website"
  value       = "https://storage.googleapis.com/${google_storage_bucket.website.name}/index.html"
}

output "gcs_project_id" {
  description = "GCP project ID"
  value       = var.gcp_project_id
}
