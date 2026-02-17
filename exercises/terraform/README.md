# Terraform Exercise Summary

This project demonstrates a standard Terraform workflow for deploying infrastructure on AWS. We started by configuring a basic EC2 instance in the `eu-north-1` region and iteratively improved the configuration to follow industry best practices for modularity and maintainability.

### Key Implementation Details

1.  **Refactored Project Structure**: To improve organization, we split the configuration into logical files: `providers.tf` for versioning and provider setup, `main.tf` for core resources, `variables.tf` for input parameterization, and `outputs.tf` for retrieving essential resource data like the instance's public IP.
2.  **Dynamic AMI Selection**: Instead of hardcoding AMI IDs, we implemented a `data "aws_ami"` block. This dynamically fetches the latest Ubuntu 24.04 image, ensuring the configuration remains portable and up-to-date.
3.  **Security and Connectivity**: We introduced an `aws_security_group` resource named `aidas-sg` that explicitly allows inbound SSH traffic on port 22. This security group is programmatically attached to the EC2 instance using its resource ID, demonstrating cross-resource dependencies.
4.  **Parameterization**: By utilizing Terraform variables with an `aidas-` naming convention, we've made the infrastructure easily customizable. The final deployment outputs the public IP of the `t3.micro` instance, allowing for immediate verification and access.

### Cleanup

To remove all created resources and avoid incurring unnecessary costs, use the following command:

```bash
terraform destroy -auto-approve
```

**Note:** Always verify in the AWS Console that all resources have been terminated to ensure no unexpected charges occur.


