output "sns_topic_arn" {
  description = "The ARN of the SNS topic"
  value       = aws_sns_topic.topic.arn
}

output "sqs_queue_1_url" {
  description = "The URL of SQS Queue 1"
  value       = aws_sqs_queue.queue_1.url
}

output "sqs_queue_2_url" {
  description = "The URL of SQS Queue 2"
  value       = aws_sqs_queue.queue_2.url
}
