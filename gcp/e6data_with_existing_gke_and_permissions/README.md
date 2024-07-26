# Creating Workspaces in GCP using Kubernetes <!-- omit in toc -->

These Terraform files are used to create an e6data Workspace using Kubernetes inside an existing Kubernetes cluster.

Prior to running these scripts, please follow the instructions in this document to make the changes required to adapt them to your environment.

- [Prerequisites](#prerequisites)
- [Installing the e6data Workspace](#installing-the-e6data-workspace)
  - [1. Download e6data Terraform Scripts](#1-download-e6data-terraform-scripts)
  - [2. Configure the `provider.tf` file](#2-configure-the-providertf-file)
  - [3. Configure variables in the `terraform.tfvars` file](#3-configure-variables-in-the-terraformtfvars-file)
  - [4. Execute Terraform Script](#4-execute-terraform-script)

## Prerequisites
1. A Google Cloud Platform (GCP) account with [sufficient permissions to create and manage resources.](https://docs.e6data.com/product-documentation/workspaces/creating-workspaces-in-gcp#deployment-overview-and-resource-provisioning)
2. A local development environment with [Terraform installed](https://docs.e6data.com/product-documentation/workspaces/creating-workspaces-in-gcp#installing-terraform).
3. A [Google Kubernetes Engine (GKE) cluster.](https://docs.e6data.com/product-documentation/workspaces/creating-workspaces-in-gcp#creating-a-gke-cluster-optional)
   - ODIC enabled
     - For instructions to create an OIDC Provider, refer to the official GCP Documentation: [Enable OIDC](https://cloud.google.com/kubernetes-engine/docs/how-to/oidc#enable-oidc)
4. A GCP service account should be created and granted access to the data buckets. Additionally, the necessary permissions should be assigned to the e6data service account as specified in this document. (https://docs.e6data.com/product-documentation/setup/gcp-setup/infrastructure-and-permissions-for-e6data)

## Installing the e6data Workspace

### 1. Download e6data Terraform Scripts

   1. Download this repo and extract the contents to a local environment with Terraform installed.
   2. Navigate to the `./scripts/gcp/terraform` folder

### 2. Configure the `provider.tf` file

The Google provider blocks are used to configure the credentials you use to authenticate with GCP, as well as the default project and location of your resources.

1. Edit the `provider.tf` file according to the authentication method used in your GCP environment.
   - Terraform supports multiple methods for authenticating with GCP. Please refer to the [official Terraform documentation](https://registry.terraform.io/providers/hashicorp/google/latest/docs/guides/provider_reference#authentication-configuration) and select the method most appropriate for your environment.
2. Specify a GCP bucket for storing the Terraform state by replacing `<bucket_name_to_store_the_tfstate_file>` with the target bucket name.
   - The `prefix` parameter allows you to specify a directory or path within the bucket where the Terraform state file will be stored. Adjust the `prefix` value according to your requirements.

### 3. Configure variables in the `terraform.tfvars` file

Please update the values of these variables in the `terraform.tfvars` file to match the specific configuration details for your environment:

| Variable                  | Description                                                                |
|---------------------------|----------------------------------------------------------------------------|
| workspace_name            | The name of the e6data workspace to be created.                            |
| gcp_project_id            | The Google Cloud Platform (GCP) project ID to deploy the e6data workspace. |
| gcp_region                | The GCP region to deploy the e6data workspace.                             |
| cluster_name              | The name of the target Kubernetes cluster for e6data workspace deployment. |
| kubernetes_cluster_zone   | The Kubernetes cluster zone (only required for zonal clusters).            |
| max_instances_in_nodepool | The maximum number of instances in the Kubernetes nodepool.                |
| nodepool_instance_type    | The instance type for the Kubernetes nodepool.                             |
| kubernetes_namespace      | The Kubernetes namespace to deploy the e6data workspace.                   |

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

   - This command applies the changes specified in the plan file (e6.plan) to deploy the e6data workspace in your environment.

6. Return to the e6data console and enter the outputs from the previous step.

   - This will validate & establish cross-account connectivity between the e6data control plane & the e6data workspace in the customers account.
   - Once connectivity is established, the e6data control plane will automatically send the instructions to [create the components](https://docs.e6data.com/product-documentation/workspaces/creating-workspaces-in-gcp#deployment-overview-and-resource-provisioning) of an e6data workspace.

7. All other actions like creating clusters, connecting to catalog, etc. can be carried out using the e6data console after the workspace is created.