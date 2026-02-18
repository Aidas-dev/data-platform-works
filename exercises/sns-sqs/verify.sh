#!/bin/bash
set -e

# Get outputs from Terraform
TOPIC_ARN=$(terraform output -raw sns_topic_arn)
QUEUE_1_URL=$(terraform output -raw sqs_queue_1_url)
QUEUE_2_URL=$(terraform output -raw sqs_queue_2_url)
MESSAGE="Hello from Aidas setup $(date)"

echo "------------------------------------------------"
echo "Publishing message to SNS topic: $TOPIC_ARN"
echo "Message: '$MESSAGE'"
echo "------------------------------------------------"

aws sns publish --topic-arn "$TOPIC_ARN" --message "$MESSAGE"

echo "Waiting for message delivery..."
sleep 5

echo "------------------------------------------------"
echo "Checking Queue 1: $QUEUE_1_URL"
echo "------------------------------------------------"
aws sqs receive-message --queue-url "$QUEUE_1_URL" --max-number-of-messages 1 --wait-time-seconds 5

echo "------------------------------------------------"
echo "Checking Queue 2: $QUEUE_2_URL"
echo "------------------------------------------------"
aws sqs receive-message --queue-url "$QUEUE_2_URL" --max-number-of-messages 1 --wait-time-seconds 5
