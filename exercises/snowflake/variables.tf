variable "snowflake_account" {
  description = "The Snowflake account identifier (e.g., xy12345.us-east-1)"
  type        = string
}

variable "snowflake_user" {
  description = "The Snowflake username for Terraform"
  type        = string
}

variable "snowflake_private_key" {
  description = "The private key for the Snowflake user (for key-pair authentication)"
  type        = string
  sensitive   = true
}

variable "snowflake_role" {
  description = "The Snowflake role to use for Terraform operations (default: ACCOUNTADMIN)"
  type        = string
  default     = "ACCOUNTADMIN"
}

variable "snowflake_warehouse" {
  description = "The Snowflake warehouse to use for Terraform operations (optional)"
  type        = string
  default     = "COMPUTE_WH"
}
