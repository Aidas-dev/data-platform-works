# Terraform GCS Static Website Deployment

This Terraform configuration deploys a GCS bucket configured for static website hosting, matching the requirements for the "Deploy a Static Website to GCP Cloud Storage Using GitHub Actions" lab.

## Resources Created

- **GCS Bucket** - For hosting static website content
- **IAM Binding** - `allUsers` with `roles/storage.objectViewer` for public read access
- **Website Configuration** - Static website serving with `index.html` as default page
- **Versioning** - Enabled on the bucket

## Prerequisites

- Terraform >= 1.0.0
- GCP service account with appropriate permissions
- `gcloud` CLI installed (optional, for verification)
- Hugo installed (for local preview)

## Quick Start

### 1. Authenticate with GCP

```bash
# Option A: Use gcloud (recommended)
gcloud auth application-default login

# Option B: Use service account key
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/service-account-key.json"
```

### 2. Initialize Terraform

```bash
cd terraform
terraform init
```

### 3. Create Terraform Variables File

Create a `terraform.tfvars` file:

```hcl
gcp_project_id = "your-gcp-project-id"
bucket_name    = "my-unique-website-bucket-12345"
gcp_region     = "europe-west1"
environment    = "dev"
```

> **Note:** Bucket names must be globally unique across all of GCP.

### 4. Plan and Apply

```bash
# Review the plan
terraform plan

# Apply the configuration
terraform apply
```

Type `yes` when prompted to confirm.

### 5. Get Website URL

After successful deployment, Terraform will output the website URL:

```
Outputs:

bucket_name  = "my-unique-website-bucket-12345"
bucket_url   = "https://storage.googleapis.com/my-unique-website-bucket-12345"
website_url  = "https://storage.googleapis.com/my-unique-website-bucket-12345/index.html"
```

### 6. Deploy Your Hugo Site

Build the Hugo site and sync to GCS:

```bash
# Build the site
cd hugo-site
hugo

# Sync to GCS
gsutil rsync -r public/ gs://YOUR_BUCKET_NAME/
```

### 7. Access Your Website

Open the `website_url` in your browser.

## Cleanup

To destroy all resources:

```bash
# First, empty the bucket (required before deletion)
gsutil rm -r gs://$(terraform output -raw bucket_name)/

# Then destroy Terraform resources
terraform destroy
```

Type `yes` when prompted to confirm.

## File Structure

```
terraform/
├── main.tf          # GCS bucket and related resources
├── variables.tf     # Input variables
├── outputs.tf       # Output values
├── providers.tf     # Provider configuration
└── README.md        # This file
```

## Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `gcp_project_id` | GCP project ID | `string` | - |
| `bucket_name` | GCS bucket name (globally unique) | `string` | - |
| `gcp_region` | GCP region | `string` | `"europe-west1"` |
| `environment` | Environment tag | `string` | `"dev"` |

## Outputs

| Name | Description |
|------|-------------|
| `bucket_name` | Name of the GCS bucket |
| `bucket_url` | Storage API URL for the bucket |
| `website_url` | Public URL to access the static website |
| `gcs_project_id` | GCP project ID |

## Integration with GitHub Actions

This Terraform configuration creates the GCS bucket infrastructure. To set up automated deployment via GitHub Actions:

1. Create your GitHub repository
2. Add your Hugo site files
3. Add GCP credentials as GitHub Secrets:
   - `GCP_PROJECT_ID`
   - `GCP_SA_KEY` (the full JSON service account key)
   - `GCP_BUCKET_NAME`
4. Create `.github/workflows/deploy.yml` (see the lab instructions)
5. Push your code

## Troubleshooting

### Bucket Name Already Exists

GCS bucket names must be globally unique. If you get an error, try a different bucket name.

### Access Denied

Ensure your service account has the necessary permissions:
- `storage.buckets.create`
- `storage.buckets.get`
- `storage.buckets.update`
- `storage.buckets.setIamPolicy`
- `storage.objects.create`
- `storage.objects.delete`

### Website Not Loading

1. Verify the IAM policy allows `allUsers` to read objects
2. Check that `index.html` exists in the bucket
3. Ensure the bucket has website configuration enabled
4. Check that `public_access_prevention` is not set to `enforced`

## Security Notes

- This configuration is intended for **learning/demo purposes**
- For production use, consider:
  - Using Cloud CDN in front of GCS
  - Implementing proper access controls
  - Using a custom domain with an SSL certificate
  - Setting up Cloud Armor for additional security
