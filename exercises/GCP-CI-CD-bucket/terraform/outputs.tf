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

output "sa_email" {
  description = "Service account email for GitHub Actions"
  value       = google_service_account.github_actions_deployer.email
}

output "wif_provider_name" {
  description = "Workload Identity Provider resource name"
  value       = google_iam_workload_identity_pool_provider.github_provider.name
}
