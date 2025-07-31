# Azure AD Permissions Requirements for E6Data Terraform Deployment

This document outlines all the Azure Active Directory (Azure AD) and Azure RBAC permissions required to successfully deploy the E6Data infrastructure using Terraform.

## Table of Contents
- [Overview](#overview)
- [Resources Being Created](#resources-being-created)
- [Required Permissions](#required-permissions)
- [Service Principal Setup](#service-principal-setup)
- [Custom Role Definition](#custom-role-definition)
- [Verification Steps](#verification-steps)

## Overview

The E6Data Terraform deployment creates a comprehensive Azure infrastructure including:
- Azure Kubernetes Service (AKS) cluster with advanced features
- Virtual networking components
- Storage accounts for data processing
- Managed identities with federated credentials
- Custom RBAC roles and assignments
- Key Vault integration (optional)

## Resources Being Created

### Compute Resources
- **Azure Kubernetes Service (AKS)**
  - System-assigned managed identity
  - Workload identity enabled
  - OIDC issuer enabled
  - Azure AD RBAC integration
  - Virtual node (ACI connector) enabled
  - Cilium network plugin

### Networking Resources
- **Virtual Network (VNet)**
- **Subnets**
  - AKS subnet with Microsoft.Storage service endpoints
  - ACI subnet delegated to Microsoft.ContainerInstance/containerGroups
- **Network Security Groups (NSG)**
- **NAT Gateway**
- **Public IP addresses**

### Storage Resources
- **Storage Accounts** for E6Data workspace
- **Blob Containers** for data storage

### Identity Resources
- **User Assigned Managed Identities**
  - Federated identity for cross-account access
  - E6Data engine identity
  - Karpenter identity
- **Federated Identity Credentials**
  - AWS Cognito federation
  - AKS workload identity federation

### Security Resources
- **Key Vault** (conditional)
- **Custom Role Definitions**
- **Role Assignments**

## Required Permissions

### Option 1: Built-in Roles (Broad Permissions)

Assign these roles at the **Subscription** level:
- `Contributor`
- `User Access Administrator`

### Option 2: Built-in Roles at Resource Group Level

If limiting to resource group scope, assign:
- `Contributor` on the resource group
- `User Access Administrator` on the resource group
- `Network Contributor` for VNet operations
- `Storage Account Contributor` for storage operations

### Option 3: Granular Permissions

#### Azure AD Directory Permissions
```
Application.Read.All
User.Read
Directory.Read.All
```

#### Resource Provider Permissions

**Container Service (AKS)**
```
Microsoft.ContainerService/managedClusters/write
Microsoft.ContainerService/managedClusters/read
Microsoft.ContainerService/managedClusters/delete
Microsoft.ContainerService/managedClusters/listClusterUserCredential/action
Microsoft.ContainerService/managedClusters/accessProfiles/listCredential/action
```

**Managed Identity**
```
Microsoft.ManagedIdentity/userAssignedIdentities/write
Microsoft.ManagedIdentity/userAssignedIdentities/read
Microsoft.ManagedIdentity/userAssignedIdentities/delete
Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials/write
Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials/read
Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials/delete
```

**Authorization (RBAC)**
```
Microsoft.Authorization/roleDefinitions/write
Microsoft.Authorization/roleDefinitions/read
Microsoft.Authorization/roleDefinitions/delete
Microsoft.Authorization/roleAssignments/write
Microsoft.Authorization/roleAssignments/read
Microsoft.Authorization/roleAssignments/delete
```

**Networking**
```
Microsoft.Network/virtualNetworks/write
Microsoft.Network/virtualNetworks/read
Microsoft.Network/virtualNetworks/delete
Microsoft.Network/virtualNetworks/subnets/write
Microsoft.Network/virtualNetworks/subnets/read
Microsoft.Network/virtualNetworks/subnets/delete
Microsoft.Network/virtualNetworks/subnets/join/action
Microsoft.Network/publicIPAddresses/write
Microsoft.Network/publicIPAddresses/read
Microsoft.Network/publicIPAddresses/delete
Microsoft.Network/publicIPAddresses/join/action
Microsoft.Network/natGateways/write
Microsoft.Network/natGateways/read
Microsoft.Network/natGateways/delete
Microsoft.Network/networkSecurityGroups/write
Microsoft.Network/networkSecurityGroups/read
Microsoft.Network/networkSecurityGroups/delete
Microsoft.Network/networkSecurityGroups/join/action
```

**Storage**
```
Microsoft.Storage/storageAccounts/write
Microsoft.Storage/storageAccounts/read
Microsoft.Storage/storageAccounts/delete
Microsoft.Storage/storageAccounts/listkeys/action
Microsoft.Storage/storageAccounts/blobServices/write
Microsoft.Storage/storageAccounts/blobServices/read
Microsoft.Storage/storageAccounts/blobServices/delete
Microsoft.Storage/storageAccounts/blobServices/containers/write
Microsoft.Storage/storageAccounts/blobServices/containers/read
Microsoft.Storage/storageAccounts/blobServices/containers/delete
```

**Key Vault** (if using TLS certificates)
```
Microsoft.KeyVault/vaults/write
Microsoft.KeyVault/vaults/read
Microsoft.KeyVault/vaults/delete
Microsoft.KeyVault/vaults/accessPolicies/write
Microsoft.KeyVault/vaults/accessPolicies/delete
Microsoft.KeyVault/vaults/certificates/read
```

**Resource Management**
```
Microsoft.Resources/subscriptions/resourceGroups/read
Microsoft.Resources/subscriptions/resourceGroups/write
Microsoft.Resources/subscriptions/resourceGroups/delete
Microsoft.Resources/deployments/write
Microsoft.Resources/deployments/read
Microsoft.Resources/deployments/delete
```

## Service Principal Setup

### Creating a Service Principal

1. **Using Azure CLI:**
```bash
# Create service principal
az ad sp create-for-rbac --name "e6data-terraform-sp" \
  --role "Contributor" \
  --scopes "/subscriptions/{subscription-id}"

# Assign User Access Administrator role
az role assignment create --assignee {sp-app-id} \
  --role "User Access Administrator" \
  --scope "/subscriptions/{subscription-id}"
```

2. **Using Azure Portal:**
   - Navigate to Azure Active Directory → App registrations
   - Click "New registration"
   - Name: "e6data-terraform-sp"
   - Create a client secret
   - Navigate to Subscriptions → Access control (IAM)
   - Add role assignments for Contributor and User Access Administrator

### Service Principal Configuration for Terraform

```hcl
# provider.tf
provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  
  # For Service Principal authentication
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}
```

## Custom Role Definition

Create a custom role with minimum required permissions:

### JSON Definition
```json
{
  "properties": {
    "roleName": "E6Data-Terraform-Deployer",
    "description": "Custom role for deploying E6Data infrastructure on Azure - to be scoped to specific resource groups",
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
          "Microsoft.Network/virtualNetworks/*",
          "Microsoft.Network/publicIPAddresses/*",
          "Microsoft.Network/natGateways/*",
          "Microsoft.Network/networkSecurityGroups/*",
          "Microsoft.Network/networkInterfaces/read",
          "Microsoft.Network/loadBalancers/read",
          "Microsoft.Storage/storageAccounts/*",
          "Microsoft.KeyVault/vaults/*",
          "Microsoft.Authorization/roleDefinitions/write",
          "Microsoft.Authorization/roleDefinitions/delete",
          "Microsoft.Authorization/roleDefinitions/read",
          "Microsoft.Authorization/roleAssignments/write",
          "Microsoft.Authorization/roleAssignments/read",
          "Microsoft.Authorization/roleAssignments/delete",
          "Microsoft.Compute/virtualMachines/read",
          "Microsoft.Compute/virtualMachineScaleSets/read",
          "Microsoft.KeyVault/locations/deletedVaults/purge/action",

          "Microsoft.Network/publicIPAddresses/*",
          "Microsoft.Network/virtualNetworkGateways/*",
          "Microsoft.Network/localNetworkGateways/*",
          "Microsoft.Network/connections/*",
          "Microsoft.Network/virtualNetworks/read",
          "Microsoft.Resources/subscriptions/resourceGroups/read"
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

## Resource Group Scoped Permissions

This approach provides enterprise-grade security and operational simplicity by:
1. Creating a custom role with necessary permissions at subscription level
2. Assigning the role only to the dedicated E6Data resource group
3. Maintaining strict security boundaries without operational complexity

### Implementation Steps

#### Step 1: Create the Custom Role
```bash
# Save the JSON definition to a file: e6data-custom-role.json
az role definition create --role-definition e6data-custom-role.json
```

#### Step 2: Create the Resource Group
```bash
# Create the dedicated E6Data resource group
az group create --name "e6data-rg" --location "East US"
```

#### Step 3: Assign Role to Resource Group
```bash
# Get your service principal app ID
SP_APP_ID=$(az ad sp list --display-name "e6data-terraform-sp" --query "[0].appId" -o tsv)

# Assign the custom role to the resource group only
az role assignment create \
  --assignee $SP_APP_ID \
  --role "E6Data-Terraform-Deployer" \
  --resource-group "e6data-rg"
```

#### Step 4: Verify Role Assignment
```bash
# List all role assignments for the service principal
az role assignment list --assignee $SP_APP_ID --output table

# Verify the resource group access
az role assignment list --resource-group "e6data-rg" --assignee $SP_APP_ID --output table
```

### Terraform Configuration for Deployment

Update your Terraform configuration to use the dedicated resource group:

```hcl
# variables.tf
variable "resource_group_name" {
  description = "Name of the existing resource group"
  type        = string
  default     = "e6data-rg"
}

# main.tf
data "azurerm_resource_group" "main" {
  name = var.resource_group_name
}

resource "azurerm_kubernetes_cluster" "main" {
  name                = "e6data-aks"
  location            = data.azurerm_resource_group.main.location
  resource_group_name = data.azurerm_resource_group.main.name
  # ... other configuration
}

# terraform.tfvars
resource_group_name = "e6data-rg"
```

### Benefits of Resource Group Scoped Approach

1. **🔒 Security**: Limits blast radius to only the E6Data resource group
2. **⚡ Simplicity**: No complex conditional logic or naming pattern requirements
3. **🛡️ Isolation**: Complete separation from other workloads in the subscription
4. **📊 Auditability**: Clear audit trail for all E6Data operations
5. **🔧 Maintenance**: Simple to update permissions by modifying the custom role definition
6. **🏢 Enterprise Ready**: Supports shared subscription scenarios with proper boundaries

### Using the Custom Role

```bash
# Save the JSON definition to a file: e6data-custom-role.json
az role definition create --role-definition e6data-custom-role.json

# Alternative using PowerShell
New-AzRoleDefinition -InputFile "e6data-custom-role.json"
```

## Verification Steps

### 1. Verify Service Principal Permissions
```bash
# List role assignments
az role assignment list --assignee {sp-app-id} --output table

# Check specific permissions
az ad sp show --id {sp-app-id} --query appRoles
```

### 2. Test Terraform Authentication
```bash
# Export credentials
export ARM_CLIENT_ID="{client-id}"
export ARM_CLIENT_SECRET="{client-secret}"
export ARM_TENANT_ID="{tenant-id}"
export ARM_SUBSCRIPTION_ID="{subscription-id}"

# Test with Terraform
terraform init
terraform plan
```

### 3. Validate Resource Access
```bash
# Test AKS permissions
az aks list --subscription {subscription-id}

# Test storage permissions
az storage account list --subscription {subscription-id}

# Test network permissions
az network vnet list --subscription {subscription-id}
```

## Terraform Destroy Requirements

When running `terraform destroy`, additional delete permissions are required beyond the standard create/update permissions. The following permissions are specifically needed for destruction:

### Critical Delete Permissions
- `Microsoft.ContainerService/managedClusters/delete`
- `Microsoft.ManagedIdentity/userAssignedIdentities/delete`
- `Microsoft.ManagedIdentity/userAssignedIdentities/federatedIdentityCredentials/delete`
- `Microsoft.Network/virtualNetworks/delete`
- `Microsoft.Network/virtualNetworks/subnets/delete`
- `Microsoft.Network/publicIPAddresses/delete`
- `Microsoft.Network/natGateways/delete`
- `Microsoft.Network/networkSecurityGroups/delete`
- `Microsoft.Storage/storageAccounts/delete`
- `Microsoft.Storage/storageAccounts/blobServices/delete`
- `Microsoft.Storage/storageAccounts/blobServices/containers/delete`
- `Microsoft.KeyVault/vaults/delete`
- `Microsoft.Authorization/roleDefinitions/delete`
- `Microsoft.Authorization/roleAssignments/delete`
- `Microsoft.Resources/resourceGroups/delete`

### Important Notes for Destroy Operations
1. **Resource Dependencies**: Azure enforces deletion order based on dependencies. Terraform handles this automatically.
2. **Soft Delete**: Some resources (like Key Vaults) have soft delete enabled by default and may require purge permissions.
3. **Role Assignments**: Custom role assignments must be removed before custom role definitions can be deleted.
4. **Resource Locks**: Any resource locks will prevent deletion and must be removed first.

## Troubleshooting

### Common Permission Errors

1. **"AuthorizationFailed" Error**
   - Verify the service principal has the required role assignments
   - Check if the role assignments have propagated (can take up to 30 minutes)

2. **"LinkedAuthorizationFailed" Error**
   - Ensure Network Contributor role is assigned for subnet operations
   - Verify the service principal can read the resource group

3. **"MissingSubscriptionRegistration" Error**
   - Register required resource providers:
   ```bash
   az provider register --namespace Microsoft.ContainerService
   az provider register --namespace Microsoft.Network
   az provider register --namespace Microsoft.Storage
   az provider register --namespace Microsoft.ManagedIdentity
   ```

## Security Best Practices

1. **Use Managed Identities** where possible instead of service principals
2. **Implement Just-In-Time (JIT)** access for elevated permissions
3. **Regular Audit** of role assignments and permissions
4. **Use Azure Policy** to enforce compliance requirements
5. **Enable Azure AD PIM** for privileged role management
6. **Rotate credentials** regularly for service principals

## Additional Resources

- [Azure RBAC Documentation](https://docs.microsoft.com/en-us/azure/role-based-access-control/)
- [AKS Security Best Practices](https://docs.microsoft.com/en-us/azure/aks/security-best-practices)
- [Terraform AzureRM Provider Documentation](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs)
- [Azure AD Application Permissions Reference](https://docs.microsoft.com/en-us/graph/permissions-reference)

---
