# Creating Workspaces in AWS using Kubernetes <!-- omit in toc -->

These Terraform files are used to create an e6data Workspace using Kubernetes inside an existing Kubernetes cluster.

Prior to running these scripts, please follow the instructions in this document to make the changes required to adapt them to your environment.

- [Prerequisites](#prerequisites)
- [Installing the e6data Workspace](#installing-the-e6data-workspace)
  - [1. Download e6data Terraform Scripts](#1-download-e6data-terraform-scripts)
  - [2. Configure the `provider.tf` file](#2-configure-the-providertf-file)
  - [3. Configure variables in the `terraform.tfvars` file](#3-configure-variables-in-the-terraformtfvars-file)
  - [4. Execute Terraform Script](#4-execute-terraform-script)

## Prerequisites

1. An AWS account with sufficient [permissions to create and manage resources.](https://docs.e6data.com/product-documentation/workspaces/creating-workspaces-in-aws-v2-k8s#deployment-overview-and-resource-provisioning)
2. A local development environment with [Terraform installed](https://docs.e6data.com/product-documentation/workspaces/creating-workspaces-in-aws-v2-k8s#installing-terraform-locally-optional).
3. An [Amazon EKS cluster](https://docs.e6data.com/product-documentation/workspaces/creating-workspaces-in-aws-v2-k8s#creating-an-amazon-eks-cluster-optional) (v1.24+)
   - Autoscaling enabled (Cluster Autoscaler or Karpenter).
     - For instructions to set up autoscaling for Amazon EKS, refer to the official AWS documentation: [Amazon EKS Autoscaling Documentation](https://docs.aws.amazon.com/eks/latest/userguide/autoscaling.html).
   - OIDC enabled
     - For instructions to create an IAM OIDC Provider, refer to the official AWS Documentation: [Creating an IAM OIDC provider for your cluster](https://docs.aws.amazon.com/eks/latest/userguide/enable-iam-roles-for-service-accounts.html)

## Installing the e6data Workspace

### 1. Download e6data Terraform Scripts

   1. Download this repo and extract the contents to a local environment with Terraform installed.
   2. Navigate to the `./scripts/aws/terraform` folder

### 2. Configure the `provider.tf` file

The Amazon Web Services (AWS) provider in Terraform allows you to manage AWS resources efficiently. However, before utilizing the provider, it is crucial to configure it with the appropriate authentication method & credentials.

1. Edit the `provider.tf` file according to the authentication method used in your AWS environment.
   - Terraform supports multiple methods for authenticating with AWS. Please refer to the [official Terraform documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration) and select the method most appropriate for your environment.
2. Specify an AWS S3 bucket for storing the Terraform state by replacing `<bucket_name_to_store_the_tfstate_file>` with the target S3 bucket name.
   - The key parameter specifies the name of the state file within the bucket. It is set to `terraform/state.tfstate`, but it can be edited as required.

### 3. Configure variables in the `terraform.tfvars` file

Please update the values of these variables in the `terraform.tfvars` file to match the specific configuration details for your environment:

| Variable                       | Description                                                                                           |
|--------------------------------|-------------------------------------------------------------------------------------------------------|
| aws_region                     | AWS region of the EKS cluster.                                                                        |
| workspace_name                 | Name of the e6data workspace to be created.                                                           |
| eks_cluster_name               | The name of the Kubernetes cluster to deploy e6data workspace.                                        |
| eks_disk_size                  | Disk size for the disks in the node group. A minimum of 100 GB is required.                           |
| eks_capacity_type              | Options: ON_DEMAND or SPOT. The type of instances that should be created.                              |
| bucket_names                   | List of bucket names that the e6data engine queries and require read access to.                       |
| kubernetes_namespace           | Value of the Kubernetes namespace to deploy the e6data workspace.                                     |
| helm_chart_version             | e6data workspace Helm chart version to be used.                                          |

### 4. Execute Terraform Script

Once you have configured the necessary variables in the `provider.tf` & `terraform.tfvars` files, you can proceed with the deployment of the e6data workspace. Follow the steps below to initiate the deployment:

1. Navigate to the directory containing the Terraform files. It is essential to be in the correct directory for the Terraform commands to execute successfully.
2. Initialize Terraform:

```bash
terraform init
```
3. Generate a Terraform plan and save it to a file (e.g., e6.plan):

```bash
terraform plan -var-file="terraform.tfvars" --out="e6.plan"
```

- The `-var-file` flag specifies the input variable file (`terraform.tfvars`) that contains the necessary configuration values for the deployment.

4. Review the generated plan.

5. Apply the changes using the generated plan file:

```bash
terraform apply "e6.plan"
```

   - This command applies the changes specified in the plan file (e6.plan) to deploy the e6data workspace in your environment. Please note the outputs that will be displayed after the script is run.

6. Return to the e6data console and enter the outputs from the previous step.
   - This will validate & establish cross-account connectivity between the e6data control plane & the e6data workspace in the customers account.
   - Once connectivity is established, the e6data control plane will automatically send the instructions to [create the components](https://docs.e6data.com/product-documentation/workspaces/creating-workspaces-in-aws-v2-k8s#deployment-overview-and-resource-provisioning) of an e6data workspace.

7. All other actions like creating clusters, connecting to catalog, etc. can be carried out using the e6data console after the workspace is created.