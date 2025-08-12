# Azure AD Permissions Requirements for E6Data with Existing AKS

This document outlines the Azure Active Directory (Azure AD) and Azure RBAC permissions required to deploy E6Data infrastructure using an **existing Azure Kubernetes Service (AKS) cluster**.

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
- Have existing AKS clusters with established configurations
- Want to leverage existing Kubernetes infrastructure investments
- Need to comply with strict cluster management policies
- Have dedicated platform teams managing Kubernetes infrastructure
- Want to deploy E6Data as an application workload on existing clusters

## Prerequisites

The following Azure resources **must exist** before running this Terraform deployment:

### 1. **AKS Cluster**
- **Name**: Specified in `var.aks_cluster_name`
- **Resource Group**: Specified in `var.aks_resource_group_name`
- **Requirements**:
  - OIDC Issuer enabled for workload identity
  - Sufficient node capacity for E6Data workloads
  - Kubernetes version 1.24+ (for workload identity support)
  - Network connectivity for outbound internet access

### 2. **AKS Configuration Requirements**
```bash
# Verify OIDC issuer is enabled
az aks show --name "{aks-cluster}" --resource-group "{aks-rg}" --query "oidcIssuerProfile.enabled"

# Should return: true
```

### 3. **Data Storage Account**
- **Name**: Specified in `var.data_storage_account_name`
- **Resource Group**: Specified in `var.data_resource_group_name`
- **Purpose**: Contains source data for E6Data queries
- **Access**: Must allow read access from E6Data identities

### 4. **Resource Group Access**
- **AKS Resource Group**: Where the existing AKS cluster resides
- **Data Resource Group**: Where the data storage account resides
- **E6Data Resource Group**: Where new E6Data resources will be created

### 5. **Key Vault** (Optional)
- **Name**: Specified in `var.key_vault_name` (if using existing)
- **Resource Group**: Specified in `var.key_vault_rg_name`
- **Purpose**: TLS certificate storage for secure communications

### 6. **Kubernetes RBAC** (Optional)
- Admin access to the existing AKS cluster
- Permissions to create namespaces, deployments, and services
- Ability to install Helm charts

## Resources Created

This deployment creates **E6Data-specific resources only** and does not modify the existing AKS cluster infrastructure:

### Identity Resources (Azure AD)
- **Federated Identity** - For E6Data console access from AWS Cognito
- **Engine Identity** - For workload pods to access Azure storage
- **Federated Credentials** - For workload identity authentication

### Storage Resources
- **E6Data Storage Account** - Dedicated storage for E6Data workspace
- **Storage Containers** - Organized storage for different data types

### Security Resources
- **Custom Role Definitions**:
  - AKS cluster credential reader
  - Load balancer and public IP reader
  - Key Vault certificate reader
- **Role Assignments**:
  - Storage blob permissions for data access
  - Key Vault access for certificates
  - Network permissions for load balancer access

### Key Vault (Conditional)
- **New Key Vault** - Created if `var.key_vault_name` is not provided
- **Access Policies** - For certificate management

### Kubernetes Workloads (Deployed to Existing AKS)
- **E6Data Namespace** - Isolated namespace for E6Data components
- **E6Data Workspace** - Main application deployment (Helm chart)
- **Karpenter** - Cluster autoscaler (if not already present)
- **NodePool and NodeClass** - Karpenter configuration for scaling
- **NGINX Ingress Controller** - Traffic routing (optional)
- **AKV2K8S** - Azure Key Vault to Kubernetes integration (optional)
- **NVMe DaemonSet** - Storage optimization for data-intensive workloads

## Required Permissions

### Core Permissions (Reduced Scope)

Since this scenario uses existing AKS infrastructure, **fewer Azure permissions are required**:

#### **AKS Read Permissions**
```
Microsoft.ContainerService/managedClusters/read
Microsoft.ContainerService/managedClusters/listClusterUserCredential/action
Microsoft.ContainerService/managedClusters/accessProfiles/listCredential/action
```

#### **Storage Management**
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

#### **Identity Management**
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

#### **Network Read** (for LB integration)
```
Microsoft.Network/loadBalancers/read
Microsoft.Network/publicIPAddresses/read
Microsoft.Network/networkInterfaces/read
```

### Kubernetes RBAC Permissions

The service principal or user also needs Kubernetes permissions on the existing AKS cluster:

```yaml
# Required Kubernetes RBAC
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: e6data-deployer
rules:
- apiGroups: [""]
  resources: ["namespaces", "configmaps", "secrets", "services", "serviceaccounts"]
  verbs: ["create", "get", "list", "update", "patch", "delete"]
- apiGroups: ["apps"]
  resources: ["deployments", "daemonsets", "replicasets"]
  verbs: ["create", "get", "list", "update", "patch", "delete"]
- apiGroups: ["networking.k8s.io"]
  resources: ["ingresses", "networkpolicies"]
  verbs: ["create", "get", "list", "update", "patch", "delete"]
- apiGroups: ["karpenter.sh"]
  resources: ["nodepools", "nodeclasses"]
  verbs: ["create", "get", "list", "update", "patch", "delete"]
```

## Custom Role Definition

### JSON Definition
```json
{
  "properties": {
    "roleName": "E6Data-ExistingAKS-Deployer",
    "description": "Custom role for deploying E6Data on existing AKS infrastructure",
    "assignableScopes": [
      "/subscriptions/{subscription-id}"
    ],
    "permissions": [
      {
        "actions": [
          "Microsoft.Resources/subscriptions/resourceGroups/read",
          "Microsoft.Resources/deployments/*",
          "Microsoft.ContainerService/managedClusters/read",
          "Microsoft.ContainerService/managedClusters/listClusterUserCredential/action",
          "Microsoft.ContainerService/managedClusters/accessProfiles/listCredential/action",
          "Microsoft.ManagedIdentity/userAssignedIdentities/*",
          "Microsoft.Network/loadBalancers/read",
          "Microsoft.Network/publicIPAddresses/read",
          "Microsoft.Network/networkInterfaces/read",
          "Microsoft.Storage/storageAccounts/*",
          "Microsoft.KeyVault/vaults/*",
          "Microsoft.Authorization/roleDefinitions/*",
          "Microsoft.Authorization/roleAssignments/*",
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

### Step 1: Verify AKS Prerequisites
```bash
# Check AKS cluster details
az aks show --name "{aks-cluster}" --resource-group "{aks-rg}"

# Verify OIDC issuer is enabled
OIDC_ENABLED=$(az aks show --name "{aks-cluster}" --resource-group "{aks-rg}" --query "oidcIssuerProfile.enabled" -o tsv)
if [ "$OIDC_ENABLED" != "true" ]; then
  echo "Error: OIDC issuer must be enabled on the AKS cluster"
  exit 1
fi

# Get cluster credentials
az aks get-credentials --name "{aks-cluster}" --resource-group "{aks-rg}"

# Verify cluster connectivity
kubectl get nodes
```

### Step 2: Create Custom Role
```bash
# Save JSON definition to file: e6data-existing-aks-role.json
az role definition create --role-definition e6data-existing-aks-role.json
```

### Step 3: Create Resource Group for E6Data Resources
```bash
# Create dedicated resource group for E6Data-specific resources
az group create --name "e6data-prod-rg" --location "East US"
```

### Step 4: Assign Permissions
```bash
# Get service principal app ID
SP_APP_ID=$(az ad sp list --display-name "e6data-terraform-sp" --query "[0].appId" -o tsv)

# Assign role to E6Data resource group
az role assignment create \
  --assignee $SP_APP_ID \
  --role "E6Data-ExistingAKS-Deployer" \
  --resource-group "e6data-prod-rg"

# Assign AKS User role for cluster access
az role assignment create \
  --assignee $SP_APP_ID \
  --role "Azure Kubernetes Service Cluster User Role" \
  --scope "/subscriptions/{subscription-id}/resourceGroups/{aks-rg}/providers/Microsoft.ContainerService/managedClusters/{aks-cluster}"
```

### Step 5: Configure Terraform Variables
```hcl
# terraform.tfvars
# Existing infrastructure
aks_cluster_name             = "existing-aks-cluster"
aks_resource_group_name      = "aks-platform-rg"
data_storage_account_name    = "companydatalake"
data_resource_group_name     = "data-rg"

# E6Data configuration
workspace_name               = "e6data-prod"
kubernetes_namespace         = "e6data"
location                     = "East US"

# Optional: Use existing Key Vault
key_vault_name               = "company-kv"
key_vault_rg_name            = "security-rg"

# Resource group for new E6Data resources
resource_group_name          = "e6data-prod-rg"
```

### Step 6: Deploy E6Data
```bash
# Initialize Terraform
terraform init

# Plan deployment
terraform plan -var-file="terraform.tfvars"

# Apply deployment
terraform apply -var-file="terraform.tfvars"
```

## Verification

### Check E6Data Resources
```bash
# Verify new storage account
az storage account show --name "{e6data-storage-account}" --resource-group "e6data-prod-rg"

# Check managed identities
az identity list --resource-group "e6data-prod-rg" --output table

# Verify role assignments
az role assignment list --assignee $SP_APP_ID --output table
```

### Verify Kubernetes Deployment
```bash
# Check E6Data namespace
kubectl get namespace e6data

# Verify E6Data pods
kubectl get pods -n e6data

# Check Karpenter deployment
kubectl get pods -n karpenter

# Verify workload identity configuration
kubectl describe serviceaccount e6data-engine -n e6data
```

### Test Data Access
```bash
# Test storage access from E6Data pods
kubectl exec -n e6data deployment/e6data-workspace -- \
  az storage blob list --account-name "{data-storage-account}" --container-name "{container}"
```

## Benefits of Existing AKS Approach

### **Operational Benefits**
1. **🏗️ Infrastructure Reuse**: Leverages existing AKS investments
2. **👥 Team Alignment**: Works with existing platform team responsibilities
3. **📋 Policy Compliance**: Maintains existing cluster security policies
4. **💰 Cost Optimization**: No additional cluster management overhead

### **Security Benefits**
1. **🔒 Reduced Permissions**: Fewer Azure permissions required
2. **🛡️ Established Security**: Inherits existing cluster security posture
3. **📊 Centralized Monitoring**: Uses existing cluster monitoring setup
4. **🔐 Network Policies**: Leverages existing network security controls

## Key Considerations

### AKS Cluster Requirements
1. **Resource Capacity**: Ensure sufficient CPU/memory for E6Data workloads
2. **Node Scaling**: Configure cluster autoscaler or Karpenter for demand spikes
3. **Network Policies**: Verify network policies allow E6Data communication patterns
4. **Storage Classes**: Ensure appropriate storage classes for persistent workloads

### Workload Identity Setup
1. **OIDC Configuration**: Verify OIDC issuer URL is accessible
2. **Service Account**: Configure proper service account annotations
3. **Token Exchange**: Test federated credential token exchange
4. **Permissions**: Validate Azure permissions through workload identity

### Monitoring and Logging
1. **Cluster Integration**: Extend existing monitoring to E6Data namespace
2. **Log Aggregation**: Include E6Data logs in existing log management
3. **Alerting**: Configure alerts for E6Data-specific metrics
4. **Performance**: Monitor impact on existing cluster workloads

## Troubleshooting

### Common Issues

#### **OIDC Issuer Not Enabled**
```bash
# Enable OIDC issuer on existing cluster
az aks update --name "{aks-cluster}" --resource-group "{aks-rg}" --enable-oidc-issuer
```

#### **Insufficient Cluster Resources**
```bash
# Check node capacity
kubectl describe nodes

# Check resource requests/limits
kubectl top nodes
kubectl top pods -n e6data
```

#### **Workload Identity Issues**
```bash
# Verify service account configuration
kubectl describe serviceaccount e6data-engine -n e6data

# Check federated credential
az identity federated-credential list --identity-name "{identity-name}" --resource-group "e6data-prod-rg"
```

#### **Storage Access Problems**
```bash
# Test storage connectivity from pod
kubectl exec -n e6data deployment/e6data-workspace -- nslookup "{storage-account}.blob.core.windows.net"

# Verify role assignments
az role assignment list --scope "/subscriptions/{sub}/resourceGroups/{data-rg}/providers/Microsoft.Storage/storageAccounts/{storage-account}"
```

## Support Resources
- [AKS Workload Identity](https://docs.microsoft.com/en-us/azure/aks/workload-identity-overview)
- [Azure RBAC for Kubernetes](https://docs.microsoft.com/en-us/azure/aks/manage-azure-rbac)
- [Karpenter on AKS](https://docs.microsoft.com/en-us/azure/aks/karpenter)

---

Last Updated: 2024
Version: 1.0