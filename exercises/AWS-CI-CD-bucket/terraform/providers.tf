terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  # Credentials can be provided via:
  # 1. Environment variables: AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY
  # 2. AWS credentials file (~/.aws/credentials)
  # 3. IAM role for EC2 instances
  # 4. Terraform variables (not recommended for production)
}
