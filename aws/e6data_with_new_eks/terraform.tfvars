# AWS Variables
aws_region = "us-east-1" ### AWS region of the EKS cluster.

# e6data Workspace Variables
workspace_name = "cpp" ### Name of the e6data workspace to be created.
# Note: The variable workspace_name should meet the following criteria:
# a) Accepts only lowercase alphanumeric characters.
# b) Must have a minimum of 3 characters.

helm_chart_version = "2.1.7" ### e6data workspace Helm chart version to be used.

# Kubernetes Variables
kube_version             = "1.32" ### The Kubernetes cluster version. Version 1.24 or higher is required.
default_nodegroup_kube_version = "1.32"

eks_disk_size            = 100    ### Disk size for the instances in the nodepool. A minimum of 100 GB is required.
nodepool_instance_family = ["t3", "t4g", "t2", "c7g", "c7gd", "c6g", "c8g", "r8g", "i8g", "c6gd", "r6g", "r6gd", "r7g", "r7gd", "i3"]

# Network Variables
cidr_block  = "10.200.0.0/16"
excluded_az = ["us-east-1e"]

# EKS Cluster Variables
cluster_name      = "private"                                                 ### The name of the Kubernetes cluster to be created for the e6data workspace.
cluster_log_types = ["scheduler", "controllerManager", "authenticator", "audit"] ### List of the desired control plane logging to enable.

public_access_cidrs = ["0.0.0.0/0"]
###Indicates which CIDR blocks can access the Amazon EKS public API server endpoint when enabled. The default value is set to the CIDR of e6data(i.e.,44.194.151.209/32)
###Please include the IP address of the EC2 instance or the CIDR range of the local network from which Terraform is being executed.This is to allow the terraform scripts to access Kubernetes components(serviceaccounts,configmaps..etc).

# Data Bucket names
bucket_names = ["*"] ### List of bucket names that the e6data engine queries and therefore, require read access to. Default is ["*"] which means all buckets, it is advisable to change this.

# Kubernetes Namespace
kubernetes_namespace = "cpp" ### Value of the Kubernetes namespace to deploy the e6data workspace.

# Cost Tags
cost_tags = {
  app         = "e6data"
  environment = "dev"
  name        = "dev-POC-cpp-"
  type        = "internal-compute"
  team        = "PLT"
  user        = "plt@e6x.io"
  namespace   = "cpp"
  permanent   = "true"
}


# AWS Command Line Variable
aws_command_line_path = "aws" ### Specify the path to the AWS Command Line Interface executable. Run "which aws" command to get the exact path.

# ALB Ingress Controller Variables
alb_ingress_controller_namespace            = "kube-system"
alb_ingress_controller_service_account_name = "alb-ingress-controller"
alb_controller_helm_chart_version           = "1.8.1"

# Karpenter Variables
karpenter_namespace            = "kube-system" ### Namespace to deploy the karpenter
karpenter_service_account_name = "karpenter"   ### Service account name for the karpenter
karpenter_release_version      = "1.0.8"       ### Version of the karpenter Helm chart

debug_namespaces = ["kube-system"]

#### Additional ingress/egress rules for the EKS Security Group
# additional_ingress_rules = [
#   {
#     from_port   = 22
#     to_port     = 22
#     protocol    = "tcp"
#     self        = false
#     cidr_blocks = ["0.0.0.0/0"]
#   }
# ]

##Additonal egress rule to allow hive metastore port
additional_egress_rules = [
  {
    from_port   = 9083
    to_port     = 9083
    protocol    = "tcp"
    self        = false
    cidr_blocks = ["0.0.0.0/0"]
  }
]


# vpc cni addon parameters
warm_eni_target    = 0          # Number of extra ENIs (Elastic Network Interfaces) to keep available for pod assignment.
warm_prefix_target = 0          # Number of extra IP address prefixes to keep available for pod assignment.
minimum_ip_target  = 20         # Minimum number of IP addresses to keep available for pod assignment.