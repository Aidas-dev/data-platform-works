resource "aws_sqs_queue" "queue_1" {
  name = "${var.name_prefix}-queue-1"
}

resource "aws_sqs_queue" "queue_2" {
  name = "${var.name_prefix}-queue-2"
}

resource "aws_sns_topic_subscription" "sub_1" {
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.queue_1.arn
}

resource "aws_sns_topic_subscription" "sub_2" {
  topic_arn = aws_sns_topic.topic.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.queue_2.arn
}

resource "aws_sqs_queue_policy" "queue_1_policy" {
  queue_url = aws_sqs_queue.queue_1.id
  policy    = data.aws_iam_policy_document.queue_1_policy.json
}

data "aws_iam_policy_document" "queue_1_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }
    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.queue_1.arn]
    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sns_topic.topic.arn]
    }
  }
}

resource "aws_sqs_queue_policy" "queue_2_policy" {
  queue_url = aws_sqs_queue.queue_2.id
  policy    = data.aws_iam_policy_document.queue_2_policy.json
}

data "aws_iam_policy_document" "queue_2_policy" {
  statement {
    effect = "Allow"
    principals {
      type        = "Service"
      identifiers = ["sns.amazonaws.com"]
    }
    actions   = ["sqs:SendMessage"]
    resources = [aws_sqs_queue.queue_2.arn]
    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = [aws_sns_topic.topic.arn]
    }
  }
}
