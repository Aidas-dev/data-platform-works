# Snowflake with Terraform - Project Context

This `GEMINI.md` provides specific instructions for working with Snowflake deployments using Terraform in this project.

## 1. Provider Configuration
- **Provider:** Use the official `snowflake-labs/snowflake` provider.
- **Authentication:** Prefer **Key-Pair Authentication** over passwords for service accounts (CICD).
- **Region/Account:** Ensure the `account` and `region` are correctly specified in the provider block or environment variables (`SNOWFLAKE_ACCOUNT`, `SNOWFLAKE_USER`, `SNOWFLAKE_PRIVATE_KEY`).

```hcl
terraform {
  required_providers {
    snowflake = {
      source  = "snowflake-labs/snowflake"
      version = "~> 0.89" # Check for latest version using tools
    }
  }
}

provider "snowflake" {
  account = var.snowflake_account
  user    = var.snowflake_user
  # Use private key for automation
  private_key = var.snowflake_private_key
}
```

## 2. Resource Naming & Standards
- **Prefix:** All resources must use the `snowflake_` prefix (e.g., `snowflake_database`, `snowflake_warehouse`).
- **Identifiers:** Use snake_case for Terraform resource names and UPPER_CASE for Snowflake object names (e.g., `resource "snowflake_database" "prod_db" { name = "PROD_DB" }`).
- **Environment Tags:** Use comments or specific naming conventions to distinguish environments (e.g., `_DEV`, `_PROD`) if not using separate accounts.

## 3. Key Resources & Best Practices

### Warehouses (`snowflake_warehouse`)
- **Cost Control:** ALWAYS set `auto_suspend` (e.g., 60 seconds) and `auto_resume = true`.
- **Sizing:** Start with `x-small` or `small` unless there is a specific performance requirement.

### Databases & Schemas
- **Management:** Explicitly manage databases (`snowflake_database`) and schemas (`snowflake_schema`).
- **Transient:** Use `transient` databases/tables for staging data to reduce storage costs (no Fail-safe).

### Security & IAM
- **RBAC:** Use `snowflake_role` and `snowflake_grant_...` resources to implement Role-Based Access Control.
- **Hierarchy:** Create a role hierarchy (e.g., functional roles like `DATA_ENGINEER`, `ANALYST`) rather than granting privileges directly to users.
- **Least Privilege:** Grant only necessary privileges (USAGE on DB/Schema, SELECT on Tables).

## 4. Workflow & Tools
- **Discovery:** BEFORE writing code, use `search-opentofu-registry` to find the correct resource names.
- **Documentation:** Use `get-resource-docs` (e.g., `namespace="snowflake-labs" name="snowflake" resource="warehouse"`) to check available arguments and default values.
- **Validation:** Always run `terraform validate` after generating code.

## 5. Specific Directives for Gemini
- When asked to create a resource, **check the documentation first** using the available tools to ensure arguments are up-to-date.
- If the user asks for a "best practice" setup, assume they want **Key-Pair auth** and **Auto-Suspend** enabled.
- Warn the user if they are about to commit sensitive data (like private keys) to the repo. Suggest using `variables.tf` and `*.tfvars` (ignored by git).
