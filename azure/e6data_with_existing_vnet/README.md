# e6data with Existing VNet - Azure Terraform Deployment

This Terraform module deploys e6data workspace infrastructure on Azure using an **existing Virtual Network (VNet)** while creating a new AKS cluster.

## Prerequisites

For detailed prerequisites, see the [e6data Azure Setup Documentation](https://docs.e6data.com/product-documentation/setup/azure-setup/in-vpc-deployment-azure/prerequisite-infrastructure).

## Architecture

This module creates:
- New AKS cluster with OIDC and Workload Identity enabled
- Network subnets within existing VNet (AKS, ACI, ALB)
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
vnet_name               = "your-existing-vnet"
admin_group_object_ids  = ["your-aad-group-object-id"]

# Network CIDRs (must be within your VNet address space)
aks_subnet_cidr = ["10.x.x.x/24"]
aci_subnet_cidr = ["10.x.x.x/24"]
alb_subnet_cidr = ["10.x.x.x/24"]  # Required for AGFC

# Data storage (existing)
data_storage_account_name = "your-storage-account"
data_resource_group_name  = "your-storage-rg"

# AGFC Configuration
agfc_enabled         = true
alb_controller_version = "1.7.12"
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

## Toggle Variables

Control what gets deployed:

| Variable | Description | Default |
|----------|-------------|---------|
| `agfc_enabled` | Enable/disable AGFC deployment | `true` |
| `alb_controller_enabled` | Enable/disable ALB Controller | `true` |

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

Ensure your subnet CIDRs don't overlap with existing subnets in the VNet and are within the VNet's address space.

### Error: cannot re-use a name that is still in use

The ALB controller helm release already exists. Either:
- Import it: `terraform import helm_release.alb_controller kube-system/alb-controller`
- Or uninstall first: `helm uninstall alb-controller -n kube-system`

## Variables Reference

| Variable | Description | Required |
|----------|-------------|----------|
| `subscription_id` | Azure subscription ID | Yes |
| `aks_resource_group_name` | Resource group for AKS | Yes |
| `vnet_name` | Existing VNet name | Yes |
| `aks_subnet_cidr` | CIDR for AKS subnet | Yes |
| `aci_subnet_cidr` | CIDR for ACI subnet | Yes |
| `alb_subnet_cidr` | CIDR for ALB subnet (min /24) | Yes (if AGFC enabled) |
| `agfc_enabled` | Enable AGFC deployment | No (default: true) |
| `alb_controller_enabled` | Enable ALB Controller | No (default: true) |
| `alb_controller_version` | ALB Controller Helm version | No (default: 1.7.12) |

See `variables.tf` and `alb-variables.tf` for complete variable reference.

## Comparison with Other Modules

| Feature | Existing VNet | Existing AKS | New AKS |
|---------|---------------|--------------|---------|
| VNet | Uses existing | Uses existing | Creates new |
| AKS Cluster | Creates new | Uses existing | Creates new |
| ALB Subnet | Auto-created in VNet | User provides ID | Auto-created |
| Subnet CIDRs | Explicitly specified | N/A | Auto-calculated |
| Use Case | Existing network, new cluster | Existing cluster | Greenfield |
