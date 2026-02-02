# e6data with Existing AKS - Azure Terraform Deployment

This Terraform module deploys e6data workspace infrastructure on an **existing** Azure Kubernetes Service (AKS) cluster.

## Prerequisites

For detailed prerequisites, see the [e6data Azure Setup Documentation](https://docs.e6data.com/product-documentation/setup/azure-setup/in-vpc-deployment-azure/prerequisite-infrastructure).

**Additional requirements for this module:**
- Existing AKS cluster with OIDC issuer and Workload Identity enabled
- ALB subnet created and delegated (if using AGFC)

## Architecture

This module deploys to an existing AKS cluster:
- Azure Application Gateway for Containers (AGFC) with ALB Controller
- Karpenter for node autoscaling
- Required IAM roles and identities
- e6data workspace components

## Pre-requisites for AGFC

Before deploying AGFC, you need to create an ALB subnet in your existing VNet:

### Create ALB Subnet (Azure CLI)

```bash
# Create subnet with delegation for Application Gateway for Containers
az network vnet subnet create \
  --name alb-subnet \
  --resource-group <your-vnet-rg> \
  --vnet-name <your-vnet-name> \
  --address-prefixes 10.x.x.x/24 \
  --delegations Microsoft.ServiceNetworking/trafficControllers
```

### Get Subnet and VNet IDs

```bash
# Get ALB Subnet ID
az network vnet subnet show \
  --name alb-subnet \
  --resource-group <your-vnet-rg> \
  --vnet-name <your-vnet-name> \
  --query id -o tsv

# Get VNet ID
az network vnet show \
  --name <your-vnet-name> \
  --resource-group <your-vnet-rg> \
  --query id -o tsv
```

## Deployment Instructions

### Step 1: Configure Variables

Update `terraform.tfvars` with your values:

```hcl
# Required variables
subscription_id         = "your-subscription-id"
aks_resource_group_name = "your-aks-resource-group"
aks_cluster_name        = "your-existing-aks-cluster"

# AGFC Configuration (required)
alb_subnet_id = "/subscriptions/.../subnets/alb-subnet"
vnet_id       = "/subscriptions/.../virtualNetworks/your-vnet"

# Data storage (existing)
data_storage_account_name = "your-storage-account"
data_resource_group_name  = "your-storage-rg"
```

### Step 2: Initialize Terraform

```bash
terraform init
```

### Step 3: Deploy Infrastructure (Phased Approach)

Since this module uses an existing AKS cluster, deployment can be simpler. However, the `kubernetes_manifest` resource still requires the ALB Controller CRDs to exist first.

**Phase 1: Deploy ALB Controller**

```bash
terraform apply -target=helm_release.alb_controller
```

**Phase 2: Deploy Remaining Resources**

```bash
terraform apply
```

### Alternative: Single Command with Auto-Approve

```bash
terraform apply -target=helm_release.alb_controller -auto-approve && \
terraform apply -auto-approve
```

## Why Phased Deployment?

The `kubernetes_manifest` resource (used for AGFC ApplicationLoadBalancer) requires the ALB Controller CRDs to be installed first. The ALB Controller Helm chart creates these CRDs, so we must:

1. First deploy the ALB controller (which creates the required CRDs)
2. Then deploy the ApplicationLoadBalancer manifest and remaining resources

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

**Note:** This only removes e6data components. Your existing AKS cluster remains untouched.

## Troubleshooting

### Error: Failed to construct REST client

This error occurs if the AKS cluster is not accessible. Ensure:
- You are logged in to Azure CLI (`az login`)
- You have access to the AKS cluster
- kubelogin is installed

### Error: Subnet not delegated

The ALB subnet must be delegated to `Microsoft.ServiceNetworking/trafficControllers`. Create/update the subnet with proper delegation.

### Error: OIDC issuer not enabled

AGFC requires OIDC issuer on the AKS cluster. Enable it:

```bash
az aks update \
  --resource-group <rg-name> \
  --name <cluster-name> \
  --enable-oidc-issuer \
  --enable-workload-identity
```

## Variables Reference

| Variable | Description | Required |
|----------|-------------|----------|
| `subscription_id` | Azure subscription ID | Yes |
| `aks_resource_group_name` | Resource group containing AKS | Yes |
| `aks_cluster_name` | Existing AKS cluster name | Yes |
| `alb_subnet_id` | ALB subnet ID (delegated) | Yes (for AGFC) |
| `vnet_id` | VNet ID where AKS is deployed | Yes (for AGFC) |
| `agfc_enabled` | Enable AGFC deployment | No (default: true) |
| `alb_controller_version` | ALB Controller Helm version | No (default: 1.7.12) |

See `variables.tf` and `alb-variables.tf` for complete variable reference.

## Comparison with Other Modules

| Feature | Existing AKS | Existing VNet | New AKS |
|---------|--------------|---------------|---------|
| AKS Cluster | Uses existing | Creates new | Creates new |
| VNet | Uses existing | Uses existing | Creates new |
| ALB Subnet | User provides ID | Auto-created | Auto-created |
| Use Case | Brownfield with existing cluster | Brownfield with existing network | Greenfield |
