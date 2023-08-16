aws_region                      = "us-east-1" ### AWS region of the EKS cluster.

workspace_name                  = "workname2" ### Name of the e6data workspace to be created.
# Note: The variable workspace_name should meet the following criteria:
# a) Accepts only lowercase alphanumeric characters.
# b) Must have a minimum of 3 characters.
# c) Must not exceed 10 characters.

kube_version                    = "1.24" ### The Kubernetes cluster version. Version 1.24 or higher is required.

max_instances_in_eks_nodegroup  = 20 ### The maximum number of instances that can be allowed in the EKS nodegroup. A minimum of 3 is required.

eks_disk_size                   = 100 ### Disk size for the disks in the node group. A minimum of 100 GB is required.
eks_capacity_type               = "ON_DEMAND" ### Options: ON_DEMAND or SPOT. The type of instances that should be created.
eks_nodegroup_instance_types    = ["c7g.16xlarge"]

vpc_id                          = "vpc-0d2eb0a55a5fe42cf" ### VPC ID in which the EKS cluster should be deployed

private_subnet_ids              = ["subnet-0c1c764725c0ee2d5", "subnet-01920f008e0880174"] ### Private subnets for the node groups

subnet_ids                      = ["subnet-01852feaf5a079cec", "subnet-0ce7aa9be606f17db"] ### Public/Private subnets for the EKS cluster

cluster_name                    = "e6data"            ### The name of the Kubernetes cluster to be created for the e6data workspace.
cluster_log_types               = ["scheduler", "controllerManager","authenticator", "audit"] ### List of the desired control plane logging to enable.

bucket_names                    = ["*"] ### List of bucket names that the e6data engine queries and therefore, require read access to. Default is ["*"] which means all buckets, it is advisable to change this.

kubernetes_namespace            = "e6data" ### Value of the Kubernetes namespace to deploy the e6data workspace.
helm_chart_version              = "1.0.1" ### e6data workspace Helm chart version to be used.


### Below are the tags which will be applied to all the resources created by this Terraform script.
cost_tags = {}

aws_command_line_path           = "aws"  ### Specify the path to the AWS Command Line Interface executable. Run "which aws" command to get exact path.

### Autoscaler variables
autoscaler_namespace            = "kube-system"          ### Namespace to deploy the cluster autoscaler
autoscaler_service_account_name = "cluster-autoscaler"   ### Service account name for the cluster autoscaler
autoscaler_helm_chart_name      = "autoscaler"           ### Name of the cluster autoscaler Helm chart
autoscaler_helm_chart_version   = "9.26.0"               ### Version of the cluster autoscaler Helm chart
