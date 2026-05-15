# e6data with New AKS - Azure Terraform Deployment

This Terraform module deploys e6data workspace infrastructure on Azure, creating a new Virtual Network (VNet) and AKS cluster from scratch.

## Prerequisites

For detailed prerequisites, see the [e6data Azure Setup Documentation](https://docs.e6data.com/product-documentation/setup/azure-setup/in-vpc-deployment-azure/prerequisite-infrastructure).

## Architecture

This module creates:
- New Virtual Network (VNet) with subnets
- AKS cluster with OIDC and Workload Identity enabled
- Network subnets (AKS, ACI, ALB, optionally internal ALB)
- Azure Application Gateway for Containers (AGFC) with ALB Controller
- Karpenter for node autoscaling
- NAT Gateway for outbound connectivity
- Required IAM roles and identities

## Deployment Instructions

### Step 1: Configure Variables

Update `terraform.tfvars` with your values:

```hcl
# Required variables
subscription_id         = "your-subscription-id"
aks_resource_group_name = "your-resource-group"
admin_group_object_ids  = ["your-aad-group-object-id"]

# Network CIDR (new VNet will be created)
cidr_block = ["10.220.0.0/16"]

# Data storage (existing)
data_storage_account_name = "your-storage-account"
data_resource_group_name  = "your-storage-rg"

# AGFC Configuration
agfc_enabled              = true
agfc_subnet_prefix_length = 8   # Creates /24 subnet
agfc_subnet_cidr_offset   = 2   # Third subnet block
```

### Step 2: Initialize Terraform

```bash
terraform init
```

### Step 3: Deploy Infrastructure (Phased Approach)

Due to the `kubernetes_manifest` resource requiring cluster connectivity during planning, deployment must be done in phases:

**Phase 1: Deploy Network and AKS Cluster**

```bash
terraform apply -target=module.network -target=module.aks_e6data
```

**Phase 2: Deploy ALB Controller**

```bash
terraform apply -target=helm_release.alb_controller
```

**Phase 3: Deploy Remaining Resources**

```bash
terraform apply
```

### Alternative: Single Command with Auto-Approve

If you want to script the deployment:

```bash
terraform apply -target=module.network -target=module.aks_e6data -auto-approve && \
terraform apply -target=helm_release.alb_controller -auto-approve && \
terraform apply -auto-approve
```

## Why Phased Deployment?

The `kubernetes_manifest` resource (used for AGFC ApplicationLoadBalancer) requires a connection to the Kubernetes cluster during the planning phase. Since the cluster doesn't exist on initial deployment, we must:

1. First create the AKS cluster
2. Then deploy the ALB controller (which creates the required CRDs)
3. Finally deploy the ApplicationLoadBalancer manifest and remaining resources

## Network Subnet Allocation

With the default configuration (`cidr_block = ["10.220.0.0/16"]`), subnets are automatically calculated:

| Subnet | Purpose | Default CIDR |
|--------|---------|--------------|
| AKS | Nodes and Pods | 10.220.0.0/18 |
| ACI | Azure Container Instances | 10.220.64.0/22 |
| ALB | Application Gateway for Containers | 10.220.80.0/24 |
| ALB Internal | Internal AGFC (if enabled) | 10.220.81.0/24 |

## Cleanup

To destroy all resources:

```bash
terraform destroy
```

## Troubleshooting

### Error: Failed to construct REST client

This error occurs when running `terraform apply` before the AKS cluster exists. Follow the phased deployment approach above.

### Error: K8sVersionNotSupported

Kubernetes version requires LTS support. Use a supported version like `1.30`, `1.32`, or `1.33`. Check available versions:

```bash
az aks get-versions --location <your-region> --query "values[].version" -o tsv
```

### Error: Subnet address space overlapping

Ensure the `cidr_block` is large enough (minimum /16 recommended) to accommodate all subnets.

## Variables Reference

| Variable | Description | Required |
|----------|-------------|----------|
| `subscription_id` | Azure subscription ID | Yes |
| `aks_resource_group_name` | Resource group for AKS | Yes |
| `cidr_block` | CIDR block for new VNet | Yes |
| `admin_group_object_ids` | AAD group IDs for AKS admin | Yes |
| `agfc_enabled` | Enable AGFC deployment | No (default: true) |
| `agfc_subnet_prefix_length` | Prefix length for ALB subnet | No (default: 8) |
| `agfc_subnet_cidr_offset` | CIDR offset for ALB subnet | No (default: 2) |
| `agfc_internal_enabled` | Enable internal AGFC | No (default: false) |
| `alb_controller_version` | ALB Controller Helm version | No (default: 1.7.12) |

See `variables.tf` and `alb-variables.tf` for complete variable reference.

## Comparison with Existing VNet Module

| Feature | New AKS | Existing VNet |
|---------|---------|---------------|
| VNet | Creates new | Uses existing |
| Subnet CIDRs | Auto-calculated | Explicitly specified |
| Use Case | Greenfield deployment | Brownfield/existing infrastructure |
