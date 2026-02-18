# SNS and SQS Fan-out Setup (Aidas)

This project implements a classic SNS-to-SQS fan-out architecture using Terraform. It deploys one SNS topic (`aidas-topic`) and two SQS queues (`aidas-queue-1` and `aidas-queue-2`) in the `eu-north-1` region. Each queue is automatically subscribed to the SNS topic, and necessary IAM policies are applied to allow the SNS service to publish messages directly into the SQS queues.

To verify the setup, a `verify.sh` script is provided. This script uses the AWS CLI to retrieve the resource identifiers from Terraform outputs, publishes a test message to the SNS topic, and then polls both SQS queues to confirm that they have each received a copy of the notification.

## Cleanup Instructions

To avoid incurring ongoing AWS charges for these resources, you should delete the deployment when you are finished. Run the following command from within the `sns-sqs` directory:

```bash
terraform destroy -auto-approve
```

This will safely remove the SNS topic, both SQS queues, their subscriptions, and the associated access policies.
