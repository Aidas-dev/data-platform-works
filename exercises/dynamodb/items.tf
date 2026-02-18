resource "aws_dynamodb_table_item" "eduardas" {
  table_name = aws_dynamodb_table.users.name
  hash_key   = aws_dynamodb_table.users.hash_key

  item = <<ITEM
{
  "UserID": {"S": "1"},
  "UserName": {"S": "Eduardas"},
  "Age": {"N": "30"},
  "Sex": {"S": "Male"}
}
ITEM
}

resource "aws_dynamodb_table_item" "aidas" {
  table_name = aws_dynamodb_table.users.name
  hash_key   = aws_dynamodb_table.users.hash_key

  item = <<ITEM
{
  "UserID": {"S": "2"},
  "UserName": {"S": "Aidas"},
  "Age": {"N": "28"},
  "Sex": {"S": "Male"}
}
ITEM
}

resource "aws_dynamodb_table_item" "mantas" {
  table_name = aws_dynamodb_table.users.name
  hash_key   = aws_dynamodb_table.users.hash_key

  item = <<ITEM
{
  "UserID": {"S": "3"},
  "UserName": {"S": "Mantas"},
  "Age": {"N": "32"},
  "Sex": {"S": "Male"}
}
ITEM
}

resource "aws_dynamodb_table_item" "vytautas" {
  table_name = aws_dynamodb_table.users.name
  hash_key   = aws_dynamodb_table.users.hash_key

  item = <<ITEM
{
  "UserID": {"S": "4"},
  "UserName": {"S": "Vytautas"},
  "Age": {"N": "35"},
  "Sex": {"S": "Male"}
}
ITEM
}
