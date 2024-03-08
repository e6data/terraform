# AWS Variables
aws_region                      = "us-east-1" ### AWS region of the EKS cluster.

# e6data Workspace Variables
workspace_name                  = "workspace" ### Name of the e6data workspace to be created.
# Note: The variable workspace_name should meet the following criteria:
# a) Accepts only lowercase alphanumeric characters.
# b) Must have a minimum of 3 characters.

helm_chart_version              = "1.0.7" ### e6data workspace Helm chart version to be used.

# Kubernetes Variables
kube_version                    = "1.28" ### The Kubernetes cluster version. Version 1.24 or higher is required.
min_instances_in_eks_nodegroup  = 0 ### The minimum number of instances that should be created in the EKS nodegroup.
desired_instances_in_eks_nodegroup = 0 ### The desired number of instances that should be created in the EKS nodegroup.
max_instances_in_eks_nodegroup  = 100 ### The maximum number of instances that can be allowed in the EKS nodegroup. A minimum of 3 is required.
eks_disk_size                   = 100 ### Disk size for the disks in the node group. A minimum of 100 GB is required.
eks_nodegroup_instance_types    = ["r7g.8xlarge","r7g.12xlarge","r7g.16xlarge", "r6g.8xlarge","r6g.12xlarge","r6g.16xlarge"]

# Network Variables
cidr_block                      = "10.200.0.0/16"
excluded_az                     = ["us-east-1e"]

# EKS Cluster Variables
cluster_name                    = "ekscluster"            ### The name of the Kubernetes cluster to be created for the e6data workspace.
cluster_log_types               = ["scheduler", "controllerManager","authenticator", "audit"] ### List of the desired control plane logging to enable.

# Data Bucket names
bucket_names                    = ["*"] ### List of bucket names that the e6data engine queries and therefore, require read access to. Default is ["*"] which means all buckets, it is advisable to change this.

# Kubernetes Namespace
kubernetes_namespace            = "namespace" ### Value of the Kubernetes namespace to deploy the e6data workspace.

# Cost Tags
cost_tags = {}

# AWS Command Line Variable
aws_command_line_path           = "aws"  ### Specify the path to the AWS Command Line Interface executable. Run "which aws" command to get the exact path.

# Autoscaler Variables
autoscaler_namespace            = "kube-system"          ### Namespace to deploy the cluster autoscaler
autoscaler_service_account_name = "cluster-autoscaler"   ### Service account name for the cluster autoscaler
autoscaler_helm_chart_name      = "autoscaler"           ### Name of the cluster autoscaler Helm chart
autoscaler_helm_chart_version   = "9.26.0"               ### Version of the cluster autoscaler Helm chart

# ALB Ingress Controller Variables
alb_ingress_controller_namespace = "kube-system"
alb_ingress_controller_service_account_name = "alb-ingress-controller"
alb_controller_helm_chart_version = "1.6.1"
