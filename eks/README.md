# Create a new EKS Cluster with prerequisites for e6data <!-- omit in toc -->

In the event that an existing EKS Cluster is not available to deploy the e6data workspace. First use these Terraform files to:
1. Create an EKS Cluster
2. Enable Autoscaler
3. Enable OIDC

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

## Installing the e6data Workspace

### 1. Download e6data Terraform Scripts

   1. Download this repo and extract the contents to a local environment with Terraform installed.
   2. Navigate to the `./terraform/eks` folder

### 2. Configure the `provider.tf` file

The Amazon Web Services (AWS) provider in Terraform allows you to manage AWS resources efficiently. However, before utilizing the provider, it is crucial to configure it with the appropriate authentication method & credentials.

1. Edit the `provider.tf` file according to the authentication method used in your AWS environment.
   - Terraform supports multiple methods for authenticating with AWS. Please refer to the [official Terraform documentation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs#authentication-and-configuration) and select the method most appropriate for your environment.
2. Specify an AWS S3 bucket for storing the Terraform state by replacing `<bucket_name_to_store_the_tfstate_file>` with the target S3 bucket name.
   - The key parameter specifies the name of the state file within the bucket. It is set to `terraform/state.tfstate`, but it can be edited as required.

### 3. Configure variables in the `terraform.tfvars` file

Please update the values of these variables in the `terraform.tfvars` file to match the specific configuration details for your environment:

| Variable                        | Description                                                                              |
|---------------------------------|------------------------------------------------------------------------------------------|
| aws_region                      | AWS region to create the EKS cluster.                                                    |
| cost_tags                       | Tags which will be applied to all the resources created by this Terraform script.        |
| vpc_id                          | VPC ID in which the EKS cluster should be deployed.                                      |
| private_subnet_ids              | Private subnets for the nodegroups.                                                      |
| subnet_ids                      | Public subnets for the EKS Cluster.                                                      |
| kube_version                    | The Kubernetes cluster version. Version 1.24 or higher is required.                      |
| cluster_name                    | The name of the Kubernetes cluster to be created for the e6data workspace.               |
| cluster_log_types               | Which logs the cluster should maintain. Default: ["scheduler", "controllerManager"]      |
| min_size                        | The minimum number of instances in the Kubernetes nodegroup. Default: 1                  |
| desired_size                    | The desired number of instances in the Kubernetes nodegroup. Default: 1                  |
| max_size                        | The maximum number of instances in the Kubernetes nodegroup. Default: 5                  |
| instance_type                   | The types of instances to be used . Default: ["t3.medium"]                               |
| capacity_type                   | The type of instance capacity to be used. Default: "SPOT"                                |
| disk_size                       | Disk size for the disks in the node group. A minimum of 100 GB is required. Default: 100 |
| aws_command_line_path           | AWS command line path                                                                    |
| autoscaler_namespace            | Namespace to deploy the Cluster Autoscaler                                               |
| autoscaler_service_account_name | Service account name for the Cluster Autoscaler                                          |
| autoscaler_helm_chart_name      | Name of the Cluster Autoscaler Helm Chart                                                |
| autoscaler_helm_chart_version   | Version of the Cluster Autoscaler Helm Chart                                             |

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

   - This command applies the changes specified in the plan file (e6.plan) to deploy the EKS Cluster in your environment. Please note the outputs that will be displayed after the script is run.

6. After these steps are complete please [follow these instructions to deploy the e6data Workspace.](/aws/README.md)