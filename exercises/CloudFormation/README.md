# CloudFormation S3 Bucket Exercise

This project demonstrates the deployment of a secure S3 bucket and an IAM role using AWS CloudFormation. The task involved identifying and fixing configuration errors in the infrastructure-as-code manifests to ensure a successful deployment.

### Key Fixes and Improvements:
- **Parameter Referencing:** Corrected the `BucketName` property in `s3.yml` to properly reference the `S3BucketName` parameter.
- **Security Configuration:** Added a missing `Principal` to the `S3BucketPolicy` to allow public read/write access as per the project requirements.
- **Global Uniqueness:** Updated `s3-parameters.json` with a globally unique bucket name (`aidas-bucket-udacity-project-123`) to avoid naming collisions in the global S3 namespace.
- **IAM Capabilities:** Identified the need for `--capabilities CAPABILITY_IAM` when deploying the stack due to the inclusion of an IAM Role resource.

### How to Manage the Stack:

**To Deploy:**
```bash
aws cloudformation create-stack 
  --stack-name aidas-s3bucket 
  --template-body file://s3.yml 
  --parameters file://s3-parameters.json 
  --capabilities CAPABILITY_IAM
```

**To Delete:**
To remove all resources created by this stack and avoid unnecessary AWS costs, run:
```bash
aws cloudformation delete-stack --stack-name aidas-s3bucket
```
