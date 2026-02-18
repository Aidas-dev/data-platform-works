variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "eu-north-1"
}

variable "table_name" {
  description = "The name of the DynamoDB table"
  type        = string
  default     = "aidas-users"
}
