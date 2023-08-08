aws_region                        = "us-east-1"         ### AWS region to deploy the EKS cluster.

cost_tags                         = { App = "e6data"}  ### Tags which will be applied to all the resources created by this Terraform script.

vpc_id                            = "vpc-abcdef1234567" ### VPC ID in which the EKS cluster should be deployed

private_subnet_ids                = [ "subnet-abcdef1234567", "subnet-abcdef1234567"] ### Private subnets for the node groups

subnet_ids                        = ["subnet-abcdef1234567", "subnet-abcdef1234567"] ### Public subnets for the EKS cluster

kube_version                      = "1.27"              ### The Kubernetes cluster version. Version 1.24 or higher is required.
cluster_name                      = "e6data"            ### The name of the Kubernetes cluster to be created for the e6data workspace.
cluster_log_types                 = ["scheduler", "controllerManager"] ### List of the desired control plane logging to enable.

min_size                          = 1                 ### The minimum number of instances in the Kubernetes nodegroup.
desired_size                      = 1                 ### The desired number of instances in the Kubernetes nodegroup.
max_size                          = 5                 ### The maximum number of instances in the Kubernetes nodegroup.
instance_type                     = ["t3.medium"]
capacity_type                     = "SPOT"

disk_size                         = 100               ### Disk size for the disks in the node group. A minimum of 100 GB is required.

aws_command_line_path             = "aws"               ### AWS command line path

### Autoscaler variables
autoscaler_namespace              = "kube-system"          ### Namespace to deploy the cluster autoscaler
autoscaler_service_account_name   = "cluster-autoscaler"   ### Service account name for the cluster autoscaler
autoscaler_helm_chart_name        = "autoscaler"           ### Name of the cluster autoscaler Helm chart
autoscaler_helm_chart_version     = "9.26.0"               ### Version of the cluster autoscaler Helm chart
