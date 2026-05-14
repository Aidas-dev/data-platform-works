terraform {
  required_version = ">= 1.0.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 5.0.0"
    }
  }
}

provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region

  # Credentials can be provided via:
  # 1. Environment variable: GOOGLE_CREDENTIALS
  # 2. gcloud auth application-default login
  # 3. Service account key file via GOOGLE_APPLICATION_CREDENTIALS
  # 4. Terraform variable (not recommended for production)
}
