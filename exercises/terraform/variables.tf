variable "aws_region" {
  description = "AWS region for resources"
  type        = string
  default     = "eu-north-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "resource_prefix" {
  description = "Prefix for resource names"
  type        = string
  default     = "aidas-"
}
