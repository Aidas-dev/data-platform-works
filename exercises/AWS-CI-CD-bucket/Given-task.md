# Lab: Deploy a Static Website to AWS S3 Using GitHub Actions

## Overview
In this lab, you will create a CI/CD pipeline that automatically deploys a static website to AWS S3 whenever you push changes to your GitHub repository.

---

## Step 1: Create a New GitHub Repository

1. Navigate to GitHub
2. Click **New repository**
3. Give it a name (e.g., `my-s3-website`)
4. Initialize with a README (optional)
5. Click **Create repository**

---

## Step 2: Add Website Files

Create a file named `index.html` with the following content:

```html
<!DOCTYPE html>
<html>
<head>
    <title>My CI/CD Website</title>
</head>
<body>
    <h1>Hello from CI/CD 🚀</h1>
    <p>If you see this, my pipeline works!</p>
</body>
</html>
```

---

## Step 3: Create an S3 Bucket

1. Navigate to **AWS S3 Console**
2. Click **Create bucket**
3. Enter a unique bucket name
4. **Uncheck** "Block all public access"
5. Click **Create bucket**

### Enable Static Website Hosting

1. Go to your bucket → **Properties** tab
2. Scroll to **Static website hosting**
3. Click **Edit**
4. Enable it
5. Set **Index document**: `index.html`
6. Click **Save changes**

### Add Bucket Policy (Make Website Public)

1. Go to **Permissions** tab
2. Scroll to **Bucket Policy**
3. Click **Edit**
4. Paste the following policy (replace `YOUR_BUCKET_NAME` with your actual bucket name):

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "PublicRead",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::YOUR_BUCKET_NAME/*"
    }
  ]
}
```

5. Click **Save changes**

---

## Step 4: Get AWS Credentials

Retrieve the following from the AWS credentials email you received:
- **Access Key ID**
- **Secret Access Key**

---

## Step 5: Add Secrets to GitHub

1. Go to your GitHub repository
2. Navigate to **Settings** → **Secrets and variables** → **Actions**
3. Click **New repository secret**

Create the following 3 secrets:

| Secret Name | Value |
|-------------|-------|
| `AWS_ACCESS_KEY_ID` | Your AWS Access Key ID |
| `AWS_SECRET_ACCESS_KEY` | Your AWS Secret Access Key |
| `AWS_REGION` | `eu-north-1` |

---

## Step 6: Create GitHub Actions Pipeline

Create the following folder structure in your repository:

```
.github/
  workflows/
    deploy.yml
```

Create `.github/workflows/deploy.yml` with the following content:

```yaml
name: Deploy to S3

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
      
      - name: Configure AWS credentials
        uses: aws-actions/configure-aws-credentials@v4
        with:
          aws-access-key-id: ${{ secrets.AWS_ACCESS_KEY_ID }}
          aws-secret-access-key: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          aws-region: ${{ secrets.AWS_REGION }}
      
      - name: Deploy to S3
        run: aws s3 sync . s3://YOUR_BUCKET_NAME --delete
```

> ⚠️ **Important**: Replace `YOUR_BUCKET_NAME` with your actual S3 bucket name.

---

## Step 7: Trigger the Pipeline

1. Make a small change in `index.html` (e.g., change the text)
2. Commit and push your changes:
   ```bash
   git add .
   git commit -m "Update index.html"
   git push origin main
   ```

---

## Step 8: Watch the Pipeline

1. Go to your GitHub repository
2. Click on the **Actions** tab
3. You should see:
   - A workflow running
   - A green checkmark ✓ when finished

---

## Step 9: Open Your Website

1. Go to **AWS S3 Console**
2. Select your bucket
3. Navigate to **Properties** → **Static website hosting**
4. Copy the **Endpoint URL**
5. Open it in your browser

🎉 **Congratulations!** Your static website is now live with automated CI/CD deployment!

---

## Troubleshooting Tips

- **Pipeline fails?** Check that your AWS secrets are correctly configured
- **Website not loading?** Verify the bucket policy allows public read access
- **403 Forbidden?** Ensure "Block all public access" is unchecked
