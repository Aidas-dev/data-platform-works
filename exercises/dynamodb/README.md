# DynamoDB Users Table (Aidas)

This exercise demonstrates the creation of an Amazon DynamoDB table (`aidas-users`) using Terraform. The table is configured with a `UserID` partition key (String) and is populated with four sample user profiles: Eduardas, Aidas, Mantas, and Vytautas. Each item includes attributes for `UserName`, `Age`, and `Sex`.

The setup follows a modular structure with separate files for provider configuration, variables, table definition, and item population. It utilizes AWS provider version `6.32.1` and is deployed in the `eu-north-1` region.

## Cleanup Instructions

To avoid costs for these resources, you should destroy the infrastructure when it is no longer needed. Run the following command from the `dynamodb` directory:

```bash
terraform destroy -auto-approve
```

This will remove the DynamoDB table and all associated items.
