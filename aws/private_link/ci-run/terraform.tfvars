# AWS Variables
aws_region = "us-east-1" ### AWS region of the EKS cluster.

# e6data Workspace Variables
workspace_name = "pilotws" ### Name of the e6data workspace to be created.
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
vpc_id      = "vpc-abcd" ### The ID of the existing VPC where the EKS cluster will be deployed.
subnet_tag_key = "type"
subnet_tag_value = "private" ### Tag key and value to identify the private subnets in the VPC where the EKS cluster will be deployed.

# IAM Role ARN for the e6data engine to access required AWS services like S3
e6data_engine_role_arn = "arn:aws:iam::1234567890:role/pilot-engine-role"

# EKS Cluster Variables
cluster_name      = "piloteks"                                                 ### The name of the Kubernetes cluster to be created for the e6data workspace.
cluster_log_types = ["scheduler", "controllerManager", "authenticator", "audit"] ### List of the desired control plane logging to enable.

# Kubernetes Namespace
kubernetes_namespace = "e6data" ### Value of the Kubernetes namespace to deploy the e6data workspace.

# Cost Tags
cost_tags = {
  app         = "e6data"
  environment = "dev"
  name        = "dev-poc"
  type        = "internal-compute"
  team        = "PLT"
  user        = "plt@e6x.io"
  namespace   = "e6data"
  permanent   = "true"
}

# AWS Command Line Variable
aws_command_line_path = "aws" ### Specify the path to the AWS Command Line Interface executable. Run "which aws" command to get the exact path.

# ALB Ingress Controller Variables
alb_ingress_controller_namespace            = "kube-system"
alb_ingress_controller_service_account_name = "alb-ingress-controller"
alb_controller_helm_chart_version           = "1.8.1"
alb_controller_image_repository             = "670514002493.dkr.ecr.us-east-1.amazonaws.com/eks/aws-load-balancer-controller"
alb_controller_image_tag                    = "v2.8.1"

# Karpenter Variables
karpenter_namespace            = "kube-system" ### Namespace to deploy the karpenter
karpenter_service_account_name = "karpenter"   ### Service account name for the karpenter
karpenter_release_version      = "1.3.2"       ### Version of the karpenter Helm chart
karpenter_controller_image_repository = "670514002493.dkr.ecr.us-east-1.amazonaws.com/eks/karpenter/controller"
karpenter_controller_image_tag        = "1.3.2"

debug_namespaces = ["kube-system"]

#### Additional ingress/egress rules for the EKS Security Group
additional_ingress_rules = [
  {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    self        = false
    cidr_blocks = ["0.0.0.0/0"]
  }
]

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
    service_name      = "com.amazonaws.vpce.us-east-1.vpce-svc-0979079467114e125"
    vpc_endpoint_type = "Interface"

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
  }

  "e6data-metrics" = {
    service_name      = "com.amazonaws.vpce.us-east-1.vpce-svc-09652db6b7fa61576"
    vpc_endpoint_type = "Interface"

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
      },
      {
        description = "Allow metrics"
        from_port   = 8080
        to_port     = 8080
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
  }

  "ecr-api" = {
    service_name      = "com.amazonaws.us-east-1.ecr.api"
    vpc_endpoint_type = "Interface"

    ingress_rules = [
      {
        description = "Allow HTTPS for ECR API"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]

    egress_rules = [
      {
        description = "Allow HTTPS for ECR API"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }

  "ecr-dkr" = {
    service_name      = "com.amazonaws.us-east-1.ecr.dkr"
    vpc_endpoint_type = "Interface"

    ingress_rules = [
      {
        description = "Allow HTTPS for Docker ECR"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]

    egress_rules = [
      {
        description = "Allow HTTPS for Docker ECR"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }

  "sts" = {
    service_name      = "com.amazonaws.us-east-1.sts"
    vpc_endpoint_type = "Interface"

    ingress_rules = [
      {
        description = "Allow HTTPS for STS"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]

    egress_rules = [
      {
        description = "Allow HTTPS for STS"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }

  "ec2" = {
    service_name      = "com.amazonaws.us-east-1.ec2"
    vpc_endpoint_type = "Interface"

    ingress_rules = [
      {
        description = "Allow HTTPS for EC2"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]

    egress_rules = [
      {
        description = "Allow HTTPS for EC2"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }

  "glue" = {
    service_name      = "com.amazonaws.us-east-1.glue"
    vpc_endpoint_type = "Interface"

    ingress_rules = [
      {
        description = "Allow HTTPS for Glue"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]

    egress_rules = [
      {
        description = "Allow HTTPS for Glue"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }

  "eks" = {
    service_name      = "com.amazonaws.us-east-1.eks"
    vpc_endpoint_type = "Interface"

    ingress_rules = [
      {
        description = "Allow HTTPS for EKS"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]

    egress_rules = [
      {
        description = "Allow HTTPS for EKS"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }

  "elb" = {
    service_name      = "com.amazonaws.us-east-1.elasticloadbalancing"
    vpc_endpoint_type = "Interface"

    ingress_rules = [
      {
        description = "Allow HTTPS for ELB"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]

    egress_rules = [
      {
        description = "Allow HTTPS for ELB"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }

  "sqs" = {
    service_name      = "com.amazonaws.us-east-1.sqs"
    vpc_endpoint_type = "Interface"

    ingress_rules = [
      {
        description = "Allow HTTPS for SQS"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]

    egress_rules = [
      {
        description = "Allow HTTPS for SQS"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }

  "pricing" = {
    service_name      = "com.amazonaws.us-east-1.pricing.api"
    vpc_endpoint_type = "Interface"

    ingress_rules = [
      {
        description = "Allow HTTPS for Pricing API"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]

    egress_rules = [
      {
        description = "Allow HTTPS for Pricing API"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }

  "iam" = {
    service_name      = "com.amazonaws.iam"
    vpc_endpoint_type = "Interface"

    ingress_rules = [
      {
        description = "Allow HTTPS for IAM"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]

    egress_rules = [
      {
        description = "Allow HTTPS for IAM"
        from_port   = 443
        to_port     = 443
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
      }
    ]
  }
}

# List of IAM principals allowed to connect to the endpoint service (provided by e6data)
allowed_principals = [
  "arn:aws:iam::245069423449:root"
]

e6data_cross_oidc_role_arn = ["arn:aws:iam::245069423449:root"]

network_load_balancer_arn =  ""  #ARN of the Network Load Balancer to use for the endpoint service kube api proxy

msk_cluster_arn = "arn:aws:kafka:us-east-1:245069423449:cluster/pilot-e6-customer-query-history/1cdca129-274a-4ef2-b0a0-f15a1f4add8b-2"