# Enable APIs required for WIF and deployment
resource "google_project_service" "iamcredentials" {
  service            = "iamcredentials.googleapis.com"
  disable_on_destroy = false
}

# Service Account for GitHub Actions deployment
resource "google_service_account" "github_actions_deployer" {
  account_id   = "github-actions-deployer"
  display_name = "GitHub Actions Deployer"
  description  = "Used by GitHub Actions to deploy static site to GCS"
}

# Grant SA storage admin on the project
resource "google_project_iam_member" "sa_storage_admin" {
  project = var.gcp_project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.github_actions_deployer.email}"
}

# Workload Identity Pool for GitHub Actions
resource "google_iam_workload_identity_pool" "github_pool" {
  workload_identity_pool_id = "github-pool"
  display_name              = "GitHub Actions Pool"
  description               = "Pool for GitHub Actions OIDC authentication"
}

# OIDC Provider for GitHub Actions
resource "google_iam_workload_identity_pool_provider" "github_provider" {
  workload_identity_pool_id          = google_iam_workload_identity_pool.github_pool.workload_identity_pool_id
  workload_identity_pool_provider_id = "github-provider"
  display_name                       = "GitHub Actions Provider"
  description                        = "OIDC provider for GitHub Actions"

  attribute_mapping = {
    "google.subject"       = "assertion.sub"
    "attribute.repository" = "assertion.repository"
    "attribute.ref"        = "assertion.ref"
  }

  attribute_condition = "assertion.repository == '${var.github_repo}'"

  oidc {
    issuer_uri = "https://token.actions.githubusercontent.com"
  }
}

# Allow WIF pool to impersonate the SA
resource "google_service_account_iam_member" "wif_to_sa" {
  service_account_id = google_service_account.github_actions_deployer.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "principalSet://iam.googleapis.com/${google_iam_workload_identity_pool.github_pool.name}/*"
}

# GCS Bucket for Static Website Hosting
resource "google_storage_bucket" "website" {
  name          = var.bucket_name
  location      = var.gcp_region
  project       = var.gcp_project_id
  force_destroy = true

  versioning {
    enabled = true
  }

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }

  public_access_prevention = "inherited"

  uniform_bucket_level_access = true

  labels = {
    name        = "static-website-bucket"
    environment = var.environment
    project     = "ci-cd-demo"
  }
}

# Make bucket objects publicly readable
resource "google_storage_bucket_iam_member" "public_read" {
  bucket = google_storage_bucket.website.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"

  depends_on = [google_storage_bucket.website]
}
