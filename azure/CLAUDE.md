# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Terraform Commands

### Common Operations
- **Initialize Terraform**: `terraform init`
- **Format code**: `terraform fmt -recursive`
- **Validate configuration**: `terraform validate`
- **Plan changes**: `terraform plan -var-file=terraform.tfvars`
- **Apply changes**: `terraform apply -var-file=terraform.tfvars`
- **Destroy resources**: `terraform destroy -var-file=terraform.tfvars`

### Working with specific scenarios
Navigate to the appropriate directory before running commands:
- `cd e6data_with_new_aks/` - For new AKS deployments
- `cd e6data_with_existing_aks/` - For existing AKS deployments
- `cd e6data_with_existing_vnet/` - For existing VNet deployments

## Architecture Overview

This repository deploys e6data on Azure using three deployment patterns:

1. **New AKS Cluster** (`e6data_with_new_aks/`): Creates complete infrastructure including VNet, AKS, and optionally a hub network with firewall
2. **Existing AKS** (`e6data_with_existing_aks/`): Deploys e6data into an existing AKS cluster
3. **Existing VNet** (`e6data_with_existing_vnet/`): Creates AKS in an existing VNet

Key architectural components:
- **AKS with Workload Identity**: Uses Azure AD workload identity for pod authentication
- **Karpenter**: Node autoscaling via Karpenter instead of native AKS autoscaling
- **Storage Integration**: Federated identity for cross-account access (AWS Cognito support)
- **Private Clusters**: All AKS clusters configured as private with restricted API access

## Module Structure

Reusable modules located in parent directory:
- `../aks_cluster/` - AKS cluster creation
- `../azure_aks_network/` - Network infrastructure
- `../azure_containers/` - Storage container management
- `../azure_hub_network/` - Hub network with firewall
- `../karpenter/` - Karpenter deployment

## Current Branch Work

Branch `az-without-nat` contains modifications to:
- `e6data_with_new_aks/aks.tf`
- `e6data_with_new_aks/support.tf`

This appears to be implementing AKS deployment without NAT gateway for outbound traffic.

## Key Configuration Files

Each scenario directory contains:
- `terraform.tfvars` - Example configuration values
- `variables.tf` - Variable definitions
- `provider.tf` - Provider and backend configuration
- `output.tf` - Outputs for e6data console integration

## Azure Permissions

Detailed permission requirements in `AZURE_PERMISSIONS_REQUIREMENTS.md` files. Key permission models:
- Broad permissions for quick setup
- Granular permissions for enterprise deployments
- Custom role definitions available

## Important Variables

Critical variables to configure:
- `subscription_id` - Azure subscription ID
- `identity_pool_id` & `identity_id` - From e6data console
- `admin_group_object_ids` - Azure AD groups for cluster admin
- `data_storage_account_name` - Storage account for e6data workspace
- `key_vault_name` - Optional for TLS certificates

## Backend Configuration

Terraform state stored in Azure Storage. Update backend configuration in `provider.tf`:
```hcl
backend "azurerm" {
  resource_group_name  = "your-rg"
  storage_account_name = "your-storage"
  container_name       = "your-container"
  key                  = "terraform.tfstate"
}
```