# AWS Variables
aws_region = "us-east-1" ### AWS region of the EKS cluster.

# e6data Workspace Variables
workspace_name = "newekscpp" ### Name of the e6data workspace to be created.
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
vpc_id      = "vpc-00cbf4aea6ca78138"

# IAM Role ARN for the e6data engine to access required AWS services like S3
e6data_engine_role_arn = "arn:aws:iam::670514002493:role/e6data-newekscpp-engine-role"

# EKS Cluster Variables
cluster_name      = "newekscpp"                                                 ### The name of the Kubernetes cluster to be created for the e6data workspace.
cluster_log_types = ["scheduler", "controllerManager", "authenticator", "audit"] ### List of the desired control plane logging to enable.

# Kubernetes Namespace
kubernetes_namespace = "e6data" ### Value of the Kubernetes namespace to deploy the e6data workspace.

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
karpenter_release_version      = "1.3.2"       ### Version of the karpenter Helm chart

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
  # {
  #   from_port   = 9083
  #   to_port     = 9083
  #   protocol    = "tcp"
  #   self        = false
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
]

# vpc cni addon parameters
warm_eni_target    = 0          # Number of extra ENIs (Elastic Network Interfaces) to keep available for pod assignment.
warm_prefix_target = 0          # Number of extra IP address prefixes to keep available for pod assignment.
minimum_ip_target  = 20         # Minimum number of IP addresses to keep available for pod assignment.

# PrivateLink Interface Endpoint configurations for logs and metrics
interface_vpc_endpoints = {
  "e6data-logs" = {
    # Service name provided by e6data for log ingestion
    service_name = "com.amazonaws.vpce.us-east-1.vpce-svc-02ae494b80ed1af07"

    ingress_rules = [
      {
        description = "Allow HTTP traffic"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "Allow HTTPS traffic"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]

    egress_rules = [
      {
        description = "Allow HTTP traffic"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "Allow HTTPS traffic"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]

    vpc_endpoint_type = "Interface"
  }

  "e6data-metrics" = {
    # Service name provided by e6data for metrics ingestion
    service_name = "com.amazonaws.vpce.us-east-1.vpce-svc-013de62cc021280a1"

    ingress_rules = [
      {
        description = "Allow HTTP traffic"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "Allow HTTPS traffic"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]

    egress_rules = [
      {
        description = "Allow HTTP traffic"
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      },
      {
        description = "Allow HTTPS traffic"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]

    vpc_endpoint_type = "Interface"
  }
}

# List of IAM principals allowed to connect to the endpoint service (provided by e6data)
allowed_principals = [
  "arn:aws:iam::442042515899:root"
]

# NGINX image configuration (must be accessible by the EKS cluster)
nginx_image_repository = "442042515899.dkr.ecr.us-east-1.amazonaws.com/nginx"   # Private ECR repo with nginx alpine image
nginx_image_tag        = "latest"  # Corresponding image tag