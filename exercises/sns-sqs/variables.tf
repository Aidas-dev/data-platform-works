variable "aws_region" {
  description = "The AWS region to deploy to"
  type        = string
  default     = "eu-north-1"
}

variable "name_prefix" {
  description = "The prefix for resource names"
  type        = string
  default     = "aidas"
}
