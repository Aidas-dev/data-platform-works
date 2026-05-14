# GCS Bucket for Static Website Hosting
resource "google_storage_bucket" "website" {
  name          = var.bucket_name
  location      = var.gcp_region
  project       = var.gcp_project_id
  force_destroy = true

  # Enable versioning for the bucket
  versioning {
    enabled = true
  }

  # Configure static website serving
  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }

  public_access_prevention = "inherited"

  # Uniform bucket-level access for consistent IAM
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


