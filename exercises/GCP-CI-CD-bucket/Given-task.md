# Lab: Deploy a Hugo Static Website to GCP Cloud Storage Using GitHub Actions

## Overview

In this lab, you will create a CI/CD pipeline that automatically builds a **Hugo** static site and deploys it to a **GCP Cloud Storage (GCS) bucket** whenever you push changes to your GitHub repository. The pipeline also runs **linting checks** on your markdown content and generated HTML.

---

## Architecture

```
Git Push → GitHub Actions → markdownlint → Hugo Build → htmlhint → gsutil sync → GCS Bucket → Public URL
```

---

## Step 1: Create a New GitHub Repository

1. Navigate to [GitHub](https://github.com)
2. Click **New repository**
3. Give it a name (e.g., `my-gcs-website`)
4. Initialize with a README (optional)
5. Click **Create repository**

---

## Step 2: Add the Hugo Site Files

The exercise includes a pre-configured Hugo site inside `hugo-site/`:

```
hugo-site/
├── hugo.toml              # Site configuration
├── content/
│   └── _index.md          # Homepage content (markdown)
├── layouts/
│   ├── _default/
│   │   └── baseof.html    # Base template
│   │   └── list.html      # List page template
│   └── index.html         # Homepage template
├── static/                # Static assets (CSS, images, JS)
└── archetypes/
    └── default.md         # Content archetype
```

### Run the Site Locally (Optional)

```bash
# Install Hugo (if not already installed)
# https://gohugo.io/installation/

# Serve with live reload
cd hugo-site
hugo server -D

# Open http://localhost:1313 in your browser
```

---

## Step 3: Create a GCS Bucket

### Option A: Using Terraform (Recommended)

The `terraform/` directory contains everything you need:

```bash
cd terraform

# Set up GCP credentials
export GOOGLE_APPLICATION_CREDENTIALS="/path/to/your/key.json"

# Initialize Terraform
terraform init

# Create a terraform.tfvars file
cat > terraform.tfvars << EOF
gcp_project_id = "your-gcp-project-id"
bucket_name    = "my-unique-website-bucket-12345"
gcp_region     = "europe-west1"
environment    = "dev"
EOF

# Apply
terraform apply
```

### Option B: Using gcloud CLI

1. **Create a bucket:**
   ```bash
   gsutil mb -l EUROPE-WEST1 gs://YOUR_UNIQUE_BUCKET_NAME
   ```

2. **Enable static website serving:**
   ```bash
   gsutil web set -m index.html -e 404.html gs://YOUR_UNIQUE_BUCKET_NAME
   ```

3. **Make objects publicly readable:**
   ```bash
   gsutil iam ch allUsers:objectViewer gs://YOUR_UNIQUE_BUCKET_NAME
   ```

---

## Step 4: Set Up Workload Identity Federation (WIF)

Your GCP org disables service account key creation. Instead, set up **Workload Identity Federation** to let GitHub Actions impersonate a service account without keys.

### Create a Service Account

1. Go to **IAM & Admin** → **Service Accounts** in GCP Console
2. Click **Create Service Account** → Name it `github-actions-deployer`
3. Assign role: **Storage Admin** (`roles/storage.admin`)
4. Click **Done**

### Create a Workload Identity Pool

```bash
gcloud iam workload-identity-pools create "github-pool" \
  --location="global" \
  --display-name="GitHub Actions Pool"
```

### Add an OIDC Provider

```bash
gcloud iam workload-identity-pools providers create-oidc "github-provider" \
  --location="global" \
  --workload-identity-pool="github-pool" \
  --display-name="GitHub Provider" \
  --attribute-mapping="google.subject=assertion.sub,attribute.repository=assertion.repository,attribute.ref=assertion.ref" \
  --attribute-condition="assertion.repository == 'YOUR_ORG/YOUR_REPO'" \
  --issuer-uri="https://token.actions.githubusercontent.com"
```

Replace `YOUR_ORG/YOUR_REPO` with your GitHub repository (e.g., `my-org/my-repo`).

### Grant the SA Impersonation Permission

```bash
gcloud iam service-accounts add-iam-policy-binding \
  "github-actions-deployer@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/projects/$(gcloud projects describe YOUR_PROJECT_ID --format='value(projectNumber)')/locations/global/workloadIdentityPools/github-pool/*"
```

---

## Step 5: Add Secrets to GitHub

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**

Create the following 3 secrets:

| Secret Name | Value |
|-------------|-------|
| `GCP_WIF_PROVIDER` | Workload Identity Provider resource name: `projects/YOUR_PROJECT_NUMBER/locations/global/workloadIdentityPools/github-pool/providers/github-provider` |
| `GCP_SA_EMAIL` | Service account email: `github-actions-deployer@YOUR_PROJECT_ID.iam.gserviceaccount.com` |
| `GCP_BUCKET_NAME` | Your GCS bucket name (e.g., `my-unique-website-bucket-12345`) |

---

## Step 6: Add the CI/CD Pipeline

Create the following folder structure in your repository:

```
.github/
  workflows/
    deploy.yml
    lint.yml
```

### Deploy Workflow (`.github/workflows/deploy.yml`)

```yaml
name: Deploy to GCS

on:
  push:
    branches:
      - main

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v3
        with:
          hugo-version: '0.145.0'
          extended: true

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install linters
        run: |
          npm install -g markdownlint-cli2 htmlhint

      - name: Lint markdown
        run: markdownlint-cli2 "hugo-site/content/**/*.md"
        continue-on-error: true

      - name: Build Hugo site
        run: hugo --gc --minify
        working-directory: hugo-site

      - name: Lint generated HTML
        run: npx htmlhint "hugo-site/public/**/*.html"
        continue-on-error: true

      - name: Authenticate to GCP
        uses: google-github-actions/auth@v2
        with:
          workload_identity_provider: ${{ secrets.GCP_WIF_PROVIDER }}
          service_account: ${{ secrets.GCP_SA_EMAIL }}

      - name: Setup gcloud CLI
        uses: google-github-actions/setup-gcloud@v2

      - name: Deploy to GCS bucket
        run: |
          gsutil rsync -r hugo-site/public/ gs://${{ secrets.GCP_BUCKET_NAME }}/
          echo "Deployed to: https://storage.googleapis.com/${{ secrets.GCP_BUCKET_NAME }}/index.html"

      - name: Smoke test - verify site is live
        run: |
          URL="https://storage.googleapis.com/${{ secrets.GCP_BUCKET_NAME }}/index.html"
          HTTP_STATUS=$(curl -s -o /dev/null -w "%{http_code}" "$URL")
          if [ "$HTTP_STATUS" -ne 200 ]; then
            echo "Smoke test FAILED - HTTP $HTTP_STATUS"
            exit 1
          fi
          echo "Smoke test PASSED - HTTP 200"
```

### Lint Workflow (`.github/workflows/lint.yml`)

```yaml
name: Lint

on:
  pull_request:
    branches:
      - main

jobs:
  lint:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Hugo
        uses: peaceiris/actions-hugo@v3
        with:
          hugo-version: '0.145.0'
          extended: true

      - name: Setup Node.js
        uses: actions/setup-node@v4
        with:
          node-version: '20'

      - name: Install linters
        run: |
          npm install -g markdownlint-cli2 htmlhint

      - name: Lint markdown files
        run: markdownlint-cli2 "hugo-site/content/**/*.md"

      - name: Validate Hugo build
        run: hugo --gc
        working-directory: hugo-site

      - name: Lint generated HTML
        run: npx htmlhint "hugo-site/public/**/*.html"

      - name: Verify deployment files exist
        run: |
          test -f hugo-site/public/index.html
          echo "index.html generated successfully"

  terraform-validate:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3
        with:
          terraform_version: '1.9.0'

      - name: Terraform fmt check
        run: terraform fmt -check -recursive
        working-directory: terraform

      - name: Terraform init
        run: terraform init
        working-directory: terraform

      - name: Terraform validate
        run: terraform validate -var="gcp_project_id=ci-check" -var="bucket_name=ci-check-bucket"
        working-directory: terraform
```

---

## Step 7: Deploy Manually (Test Locally)

Before pushing, test the build and lint locally using the provided `Makefile`:

```bash
# Build the site
make build

# Run all linters
make lint

# Or do a full deploy (set BUCKET_NAME first)
export BUCKET_NAME=my-unique-website-bucket-12345
make deploy
```

---

## Step 8: Trigger the Pipeline

1. Make a small change in `hugo-site/content/_index.md` (e.g., change the heading text)
2. Commit and push your changes:
   ```bash
   git add .
   git commit -m "Update homepage content"
   git push origin main
   ```

---

## Step 9: Watch the Pipeline

1. Go to your GitHub repository
2. Click on the **Actions** tab
3. You should see:
   - A **Lint** workflow run (on PR) — runs markdown lint, Hugo build, HTML lint, **and Terraform validation**
   - A **Deploy to GCS** workflow run (on push to main) — builds, deploys, **and smoke-tests the live URL**
   - Green checkmarks ✓ when everything passes

---

## Step 10: Open Your Website

Open the following URL in your browser:

```
https://storage.googleapis.com/YOUR_BUCKET_NAME/index.html
```

🎉 **Congratulations!** Your Hugo static website is now live with automated CI/CD deployment and linting!

---

## Customization Ideas

- **Edit content**: Modify `hugo-site/content/_index.md` with your own text
- **Change styling**: Update the `<style>` block in `hugo-site/layouts/_default/baseof.html`
- **Add pages**: Create new `.md` files in `hugo-site/content/`
- **Add a theme**: Check out [themes.gohugo.io](https://themes.gohugo.io/) for pre-built themes
- **Add Cloud CDN**: Set up a load balancer with Cloud CDN for HTTPS and caching

---

## Troubleshooting

### Pipeline fails on "Setup Hugo"

Make sure the Hugo version exists. Check [actions-hugo releases](https://github.com/peaceiris/actions-hugo) for available versions.

### Website not loading

1. Verify the bucket IAM policy allows `allUsers` with `roles/storage.objectViewer`
2. Check that `index.html` exists in the bucket: `gsutil ls gs://YOUR_BUCKET_NAME/`
3. Ensure the bucket website config is set: `gsutil web get gs://YOUR_BUCKET_NAME/`
4. Try accessing `https://storage.googleapis.com/YOUR_BUCKET_NAME/index.html` directly

### Access denied on deploy

1. Verify the WIF provider ARN is correct in the `GCP_WIF_PROVIDER` secret
2. Ensure the service account email is correct in the `GCP_SA_EMAIL` secret
3. Verify the service account has `roles/storage.admin` on the project
4. Check the OIDC attribute condition matches your repository (`assertion.repository == 'org/repo'`)

### Linting errors

1. Fix markdown issues: `make lint-md` (or `npx markdownlint-cli2 "hugo-site/content/**/*.md"`)
2. Fix HTML issues: `make build && make lint-html` (or `npx htmlhint "hugo-site/public/**/*.html"`)
3. Check linting config in `.markdownlint.jsonc` and `.htmlhintrc`

### Smoke test fails after deploy

1. Verify the bucket is publicly readable: `gsutil iam get gs://YOUR_BUCKET_NAME/`
2. Check `allUsers` has `roles/storage.objectViewer`
3. Confirm the file was synced: `gsutil ls gs://YOUR_BUCKET_NAME/index.html`
4. Wait a few seconds — GCS is eventually consistent for IAM changes

### Terraform validate fails in CI

1. Run `terraform fmt -check -recursive` locally to find formatting issues
2. Run `terraform validate -var="gcp_project_id=test" -var="bucket_name=test-bucket"` to check config
3. Ensure all resource references are correct and variables are properly typed

### Bucket name already exists

GCS bucket names are globally unique. Use a more specific name with a random suffix.

---

## Security Notes

- This configuration is intended for **learning/demo purposes**
- The bucket is publicly readable — anyone with the URL can access it
- For production use, consider:
  - Using **Cloud CDN** with a custom domain and SSL
  - Restricting the service account to the **minimum required permissions**
  - Using **Workload Identity Federation** (no long-lived keys to manage) — already configured in this lab
  - Enabling **Cloud Armor** for DDoS protection
  - Setting up **Cloud Audit Logs** to monitor access
