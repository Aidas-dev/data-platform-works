resource "aws_dynamodb_table" "users" {
  name           = var.table_name
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "UserID"

  attribute {
    name = "UserID"
    type = "S"
  }

  tags = {
    Name        = var.table_name
    Environment = "Exercise"
  }
}
