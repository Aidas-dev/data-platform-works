# Terraform S3 Static Website Deployment

This Terraform configuration deploys an S3 bucket configured for static website hosting, matching the requirements from the "Deploy a Static Website to AWS S3 Using GitHub Actions" lab.

## Resources Created

- **S3 Bucket** - For hosting static website content
- **Public Access Block** - Configured to allow public access (required for website hosting)
- **Website Configuration** - Enables static website hosting with `index.html` as the index document
- **Bucket Policy** - Allows public read access to all objects in the bucket
- **Versioning** - Enabled for the bucket (optional but recommended)

## Prerequisites

- Terraform >= 1.0.0
- AWS credentials configured (via environment variables, AWS CLI, or IAM role)
- AWS CLI installed (optional, for verification)

## Quick Start

### 1. Configure AWS Credentials

Set your AWS credentials as environment variables:

```bash
export AWS_ACCESS_KEY_ID="your-access-key-id"
export AWS_SECRET_ACCESS_KEY="your-secret-access-key"
export AWS_REGION="eu-north-1"
```

### 2. Initialize Terraform

```bash
cd terraform
terraform init
```

### 3. Create Terraform Variables File

Create a `terraform.tfvars` file:

```hcl
bucket_name   = "my-unique-website-bucket-12345"
aws_region    = "eu-north-1"
environment   = "dev"
```

> **Note:** Bucket names must be globally unique across all of AWS. Use a unique naming convention.

### 4. Plan and Apply

```bash
# Review the plan
terraform plan

# Apply the configuration
terraform apply
```

Type `yes` when prompted to confirm.

### 5. Get Website Endpoint

After successful deployment, Terraform will output the website endpoint:

```
Outputs:
bucket_name = "my-unique-website-bucket-12345"
bucket_arn = "arn:aws:s3:::my-unique-website-bucket-12345"
website_endpoint = "my-unique-website-bucket-12345.s3-website.eu-north-1.amazonaws.com"
website_domain = "my-unique-website-bucket-12345.s3-website.eu-north-1.amazonaws.com"
bucket_url = "http://my-unique-website-bucket-12345.s3-website.eu-north-1.amazonaws.com"
```

### 6. Deploy Your Website

Upload your `index.html` to the bucket:

```bash
aws s3 cp index.html s3://$(terraform output -raw bucket_name)/
```

Or use the AWS Console to upload files.

### 7. Access Your Website

Open the `bucket_url` in your browser.

## Cleanup

To destroy all resources:

```bash
# First, empty the bucket (required before deletion)
aws s3 rm s3://$(terraform output -raw bucket_name) --recursive

# Then destroy Terraform resources
terraform destroy
```

Type `yes` when prompted to confirm.

## File Structure

```
terraform/
├── main.tf          # S3 bucket and related resources
├── variables.tf     # Input variables
├── outputs.tf       # Output values
├── providers.tf     # Provider configuration
└── README.md        # This file
```

## Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `bucket_name` | Name of the S3 bucket (must be globally unique) | `string` | - |
| `aws_region` | AWS region for the S3 bucket | `string` | `"eu-north-1"` |
| `environment` | Environment tag | `string` | `"dev"` |

## Outputs

| Name | Description |
|------|-------------|
| `bucket_name` | Name of the S3 bucket |
| `bucket_arn` | ARN of the S3 bucket |
| `website_endpoint` | Website endpoint URL |
| `website_domain` | Website domain |
| `bucket_url` | Full URL to access the static website |

## Integration with GitHub Actions

This Terraform configuration creates the S3 bucket infrastructure. To set up automated deployment via GitHub Actions:

1. Create your GitHub repository
2. Add your website files (`index.html`)
3. Add AWS credentials as GitHub Secrets:
   - `AWS_ACCESS_KEY_ID`
   - `AWS_SECRET_ACCESS_KEY`
   - `AWS_REGION`
4. Create `.github/workflows/deploy.yml` (see the lab instructions)
5. Update the bucket name in the deploy workflow

## Troubleshooting

### Bucket Name Already Exists

S3 bucket names must be globally unique. If you get an error, try a different bucket name.

### Access Denied

Ensure your AWS credentials have the necessary permissions:
- `s3:CreateBucket`
- `s3:PutBucketPolicy`
- `s3:PutBucketPublicAccessBlock`
- `s3:PutBucketWebsite`
- `s3:PutBucketVersioning`

### Website Not Loading

1. Verify the bucket policy allows public access
2. Check that `index.html` exists in the bucket
3. Ensure public access block is disabled

## Security Notes

- This configuration is intended for **learning/demo purposes**
- For production use, consider:
  - Using CloudFront in front of S3
  - Implementing proper access controls
  - Enabling server-side encryption
  - Using AWS WAF for additional security
