terraform {
  required_providers {
    snowflake = {
      source  = "snowflake-labs/snowflake"
      version = "~> 0.89"
    }
  }
}

provider "snowflake" {
  account     = var.snowflake_account
  user        = var.snowflake_user
  private_key = var.snowflake_private_key
  role        = var.snowflake_role
  warehouse   = var.snowflake_warehouse
}
