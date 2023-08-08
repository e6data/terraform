aws_region                        = "us-east-1"         ### Region to deploy the EKS cluster

cost_tags                         = { App = "e6data"}  ### Tags which will be applied to all the resources created by this Terraform script.

vpc_id                            = "vpc-08ff953619c8eaff9" ### VPC ID in which the EKS cluster should be deployed

private_subnet_ids                = [ "subnet-04b08d7c1df5d4254", "subnet-062581a1156911e03"] ### Private subnets for the node groups

subnet_ids                        = ["subnet-0bb8a91aa2ed1d670", "subnet-0dfab8bf973af69e3"] ### Public subnets for the EKS cluster

kube_version                      = "1.27"              ### Kubernetes version
cluster_name                      = "e6data"            ### Name of the EKS cluster to be deployed
cluster_log_types                 = ["scheduler", "controllerManager"] ### List of the desired control plane logging to enable.

min_size                          = "1"                 ### Minimum number of nodes in the node group
desired_size                      = "1"                 ### Desired number of nodes in the node group
max_size                          = "5"                 ### Maximum number of nodes in the node group
instance_type                     = ["t3.medium"]
capacity_type                     = "SPOT"

disk_size                         = "100"               ### Disk size for the disks in the node group

aws_command_line_path             = "aws"               ### AWS command line path

### Autoscaler variables
autoscaler_namespace              = "kube-system"          ### Namespace to deploy the cluster autoscaler
autoscaler_service_account_name   = "cluster-autoscaler"   ### Service account name for the cluster autoscaler
autoscaler_helm_chart_name        = "autoscaler"           ### Name of the cluster autoscaler Helm chart
autoscaler_helm_chart_version     = "9.26.0"               ### Version of the cluster autoscaler Helm chart
