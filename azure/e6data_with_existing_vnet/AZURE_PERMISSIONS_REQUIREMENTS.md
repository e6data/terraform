# Azure AD Permissions Requirements for E6Data with Existing VNet

This document outlines the Azure Active Directory (Azure AD) and Azure RBAC permissions required to deploy E6Data infrastructure using an **existing Virtual Network (VNet)**.

## Table of Contents
- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Resources Created](#resources-created)
- [Required Permissions](#required-permissions)
- [Custom Role Definition](#custom-role-definition)
- [Implementation Steps](#implementation-steps)
- [Verification](#verification)

## Overview

This deployment scenario is designed for organizations that:
- Have established network infrastructure in Azure
- Need to comply with existing network policies and security requirements
- Want to integrate E6Data into their existing Azure network topology
- Have centralized network management and cannot create new VNets

## Prerequisites

The following Azure resources **must exist** before running this Terraform deployment:

### 1. **Virtual Network (VNet)**
- **Name**: Specified in `var.vnet_name`
- **Location**: Must be in the same region as your AKS deployment
- **Address Space**: Must have sufficient IP space for AKS subnets
- **Required CIDR**: Ensure no conflicts with planned subnet ranges

### 2. **Resource Group**
- **AKS Resource Group**: Specified in `var.aks_resource_group_name`
- **Network Resource Group**: Where the existing VNet resides

### 3. **Data Storage Account**
- **Name**: Specified in `var.data_storage_account_name`
- **Resource Group**: Specified in `var.data_resource_group_name`
- **Purpose**: Contains data for E6Data queries
- **Access**: Service principal must have read permissions

### 4. **Azure AD Groups** (Optional)
- **Admin Groups**: For AKS administrative access
- **Object IDs**: Specified in `var.admin_group_object_ids`

### 5. **Key Vault** (Optional)
- **Name**: Specified in `var.key_vault_name` (if using existing)
- **Resource Group**: Specified in `var.key_vault_rg_name`
- **Purpose**: TLS certificate storage

## Resources Created

This deployment creates the following new resources:

### Network Resources
- **AKS Subnet** - For Kubernetes nodes and pods
- **ACI Subnet** - For Azure Container Instances (virtual nodes)
- **NAT Gateway** - For outbound internet connectivity
- **Public IP** - Associated with NAT Gateway
- **Network Associations** - Linking NAT Gateway to subnets

### Compute Resources
- **AKS Cluster** - Managed Kubernetes cluster with:
  - Azure CNI networking
  - OIDC issuer enabled
  - Workload identity enabled
  - ACI connector for virtual nodes
  - Default system node pool

### Storage Resources
- **E6Data Storage Account** - For E6Data workspace data
- **Storage Containers** - For organized data storage

### Identity Resources
- **Federated Identity** - For E6Data console access from AWS
- **Engine Identity** - For data access from AKS workloads
- **Karpenter Identity** - For cluster autoscaling operations
- **Federated Credentials** - For workload identity authentication

### Security Resources
- **Custom Role Definitions** - For granular permissions
- **Role Assignments** - Mapping identities to permissions
- **Key Vault** - (if not using existing)

### Kubernetes Workloads
- **E6Data Workspace** - Main application deployment
- **Karpenter** - Cluster autoscaler
- **NGINX Ingress Controller** - Traffic routing
- **AKV2K8S** - Key Vault integration
- **NVMe DaemonSet** - Storage optimization

## Required Permissions

### Service Principal Permissions

The service principal or user account needs the following permissions:

#### **Existing VNet Permissions**
```
Microsoft.Network/virtualNetworks/read
Microsoft.Network/virtualNetworks/subnets/write
Microsoft.Network/virtualNetworks/subnets/read
Microsoft.Network/virtualNetworks/subnets/join/action
```

#### **Network Infrastructure**
```
Microsoft.Network/publicIPAddresses/write
Microsoft.Network/publicIPAddresses/read
Microsoft.Network/publicIPAddresses/delete
Microsoft.Network/publicIPAddresses/join/action
Microsoft.Network/natGateways/write
Microsoft.Network/natGateways/read
Microsoft.Network/natGateways/delete
Microsoft.Network/networkSecurityGroups/read
Microsoft.Network/networkSecurityGroups/join/action
```

#### **AKS Cluster**
```
Microsoft.ContainerService/managedClusters/write
Microsoft.ContainerService/managedClusters/read
Microsoft.ContainerService/managedClusters/delete
Microsoft.ContainerService/managedClusters/listClusterUserCredential/action
Microsoft.ContainerService/managedClusters/accessProfiles/listCredential/action
```

#### **Storage Accounts**
```
Microsoft.Storage/storageAccounts/write
Microsoft.Storage/storageAccounts/read
Microsoft.Storage/storageAccounts/delete
Microsoft.Storage/storageAccounts/listkeys/action
Microsoft.Storage/storageAccounts/blobServices/write
Microsoft.Storage/storageAccounts/blobServices/read
Microsoft.Storage/storageAccounts/blobServices/containers/write
Microsoft.Storage/storageAccounts/blobServices/containers/read
```

#### **Managed Identities**
```
Microsoft.ManagedIdentity/userAssignedIdentities/write
Microsoft.ManagedIdentity/userAssignedIdentities/read
Microsoft.ManagedIdentity/userAssignedIdentities/delete
Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials/write
Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials/read
Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials/delete
```

#### **RBAC Management**
```
Microsoft.Authorization/roleDefinitions/write
Microsoft.Authorization/roleDefinitions/read
Microsoft.Authorization/roleDefinitions/delete
Microsoft.Authorization/roleAssignments/write
Microsoft.Authorization/roleAssignments/read
Microsoft.Authorization/roleAssignments/delete
```

#### **Key Vault** (if used)
```
Microsoft.KeyVault/vaults/write
Microsoft.KeyVault/vaults/read
Microsoft.KeyVault/vaults/delete
Microsoft.KeyVault/vaults/accessPolicies/write
Microsoft.KeyVault/vaults/certificates/read
```

## Custom Role Definition

### JSON Definition
```json
{
  "properties": {
    "roleName": "E6Data-ExistingVNet-Deployer",
    "description": "Custom role for deploying E6Data infrastructure with existing VNet",
    "assignableScopes": [
      "/subscriptions/{subscription-id}"
    ],
    "permissions": [
      {
        "actions": [
          "Microsoft.Resources/subscriptions/resourceGroups/read",
          "Microsoft.Resources/deployments/*",
          "Microsoft.ContainerService/managedClusters/*",
          "Microsoft.ManagedIdentity/userAssignedIdentities/*",
          "Microsoft.Network/virtualNetworks/read",
          "Microsoft.Network/virtualNetworks/subnets/*",
          "Microsoft.Network/publicIPAddresses/*",
          "Microsoft.Network/natGateways/*",
          "Microsoft.Network/networkSecurityGroups/read",
          "Microsoft.Network/networkSecurityGroups/join/action",
          "Microsoft.Network/networkInterfaces/read",
          "Microsoft.Network/loadBalancers/read",
          "Microsoft.Storage/storageAccounts/*",
          "Microsoft.KeyVault/vaults/*",
          "Microsoft.Authorization/roleDefinitions/*",
          "Microsoft.Authorization/roleAssignments/*",
          "Microsoft.Compute/virtualMachines/read",
          "Microsoft.Compute/virtualMachineScaleSets/read",
          "Microsoft.KeyVault/locations/deletedVaults/purge/action"
        ],
        "notActions": [],
        "dataActions": [
          "Microsoft.Storage/storageAccounts/blobServices/containers/blobs/*",
          "Microsoft.KeyVault/vaults/certificates/read"
        ],
        "notDataActions": []
      }
    ]
  }
}
```

## Implementation Steps

### Step 1: Verify Prerequisites
```bash
# Check existing VNet
az network vnet show --name "{vnet-name}" --resource-group "{vnet-rg}"

# Check existing data storage account
az storage account show --name "{data-storage-account}" --resource-group "{data-rg}"

# Verify available IP space in VNet
az network vnet subnet list --vnet-name "{vnet-name}" --resource-group "{vnet-rg}" --output table
```

### Step 2: Create Custom Role
```bash
# Save JSON definition to file: e6data-existing-vnet-role.json
az role definition create --role-definition e6data-existing-vnet-role.json
```

### Step 3: Create Resource Group
```bash
# Create dedicated resource group for E6Data resources
az group create --name "e6data-prod-rg" --location "East US"
```

### Step 4: Assign Permissions
```bash
# Get service principal app ID
SP_APP_ID=$(az ad sp list --display-name "e6data-terraform-sp" --query "[0].appId" -o tsv)

# Assign role to E6Data resource group
az role assignment create \
  --assignee $SP_APP_ID \
  --role "E6Data-ExistingVNet-Deployer" \
  --resource-group "e6data-prod-rg"

# If VNet is in different resource group, assign Network Contributor
az role assignment create \
  --assignee $SP_APP_ID \
  --role "Network Contributor" \
  --resource-group "{vnet-resource-group}"
```

### Step 5: Configure Terraform Variables
```hcl
# terraform.tfvars
# Existing infrastructure
vnet_name                    = "existing-vnet"
vnet_resource_group_name     = "network-rg"
aks_resource_group_name      = "e6data-prod-rg"
data_storage_account_name    = "companydatalake"
data_resource_group_name     = "data-rg"

# New resource configuration
workspace_name               = "e6data-prod"
location                     = "East US"
aks_subnet_cidr              = "10.1.1.0/24"
aci_subnet_cidr              = "10.1.2.0/24"

# Optional: Key Vault
key_vault_name               = "company-kv"
key_vault_rg_name            = "security-rg"
```

## Verification

### Check Network Integration
```bash
# Verify subnets were created in existing VNet
az network vnet subnet list --vnet-name "{vnet-name}" --resource-group "{vnet-rg}" --output table

# Check NAT Gateway configuration
az network nat gateway show --name "{nat-gateway-name}" --resource-group "e6data-prod-rg"
```

### Verify AKS Cluster
```bash
# Check AKS cluster status
az aks show --name "{aks-cluster-name}" --resource-group "e6data-prod-rg"

# Test cluster connectivity
az aks get-credentials --name "{aks-cluster-name}" --resource-group "e6data-prod-rg"
kubectl get nodes
```

### Check Role Assignments
```bash
# Verify all role assignments
az role assignment list --assignee $SP_APP_ID --output table

# Check specific resource group permissions
az role assignment list --resource-group "e6data-prod-rg" --assignee $SP_APP_ID --output table
```

## Key Considerations

### Network Planning
1. **IP Address Space**: Ensure existing VNet has sufficient IP space for AKS subnets
2. **Subnet Conflicts**: Verify planned subnet CIDRs don't overlap with existing subnets
3. **Routing**: Consider impact of NAT Gateway on existing network routing
4. **Security Groups**: Review NSG rules for compatibility with AKS requirements

### Security Integration
1. **Existing Policies**: Ensure compliance with organizational network policies
2. **Firewall Rules**: Update firewall rules if using Azure Firewall or NVAs
3. **DNS Configuration**: Consider DNS resolution for AKS services
4. **Private Endpoints**: Plan for private endpoint integration if required

### Operational Considerations
1. **Network Monitoring**: Extend existing network monitoring to new subnets
2. **Backup Policies**: Include new resources in backup strategies
3. **Cost Management**: Monitor costs for additional network resources
4. **Change Management**: Follow existing change management processes for network modifications

## Troubleshooting

### Common Issues
1. **Insufficient IP Space**: Expand VNet address space or use smaller subnet ranges
2. **Subnet Conflicts**: Choose non-overlapping CIDR ranges
3. **Network Policy Violations**: Work with network team to resolve policy conflicts
4. **DNS Resolution**: Configure DNS settings for proper name resolution

### Support Resources
- [Azure VNet Documentation](https://docs.microsoft.com/en-us/azure/virtual-network/)
- [AKS Networking Concepts](https://docs.microsoft.com/en-us/azure/aks/concepts-network)
- [Azure CNI Networking](https://docs.microsoft.com/en-us/azure/aks/configure-azure-cni)

---

Last Updated: 2024
Version: 1.0