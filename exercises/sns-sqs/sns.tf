resource "aws_sns_topic" "topic" {
  name = "${var.name_prefix}-topic"
}
