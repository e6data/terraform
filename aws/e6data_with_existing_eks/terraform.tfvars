aws_region = "us-east-1" ### AWS region of the EKS cluster.

workspace_name = "test-pvlink" ### Name of the e6data workspace to be created.
# Note: The variable workspace_name should meet the following criteria:
# a) Accepts only lowercase alphanumeric characters.
# b) Must have a minimum of 3 characters.
# c) Must not exceed 10 characters.

eks_cluster_name = "e6data-private" ### The name of the Kubernetes cluster to deploy e6data workspace.

eks_disk_size            = 100 ### Disk size for the instances in the nodepool. A minimum of 100 GB is required.
nodepool_instance_family = ["t3", "t4g", "t2", "c7g", "c7gd", "c6g", "c8g", "r8g", "i8g", "c6gd", "r6g", "r6gd", "r7g", "r7gd", "i3"]

excluded_az = ["us-east-1e"]

bucket_names = ["*"] ### List of bucket names that the e6data engine queries and therefore, require read access to. Default is ["*"] which means all buckets, it is advisable to change this.

kubernetes_namespace = "e6data" ### Value of the Kubernetes namespace to deploy the e6data workspace.
helm_chart_version   = "2.1.7"  ### e6data workspace Helm chart version to be used.

debug_namespaces = ["kube-system"]

### Below are the tags which will be applied to all the resources created by this Terraform script.
cost_tags = {
  app = "e6data"
}

aws_command_line_path = "/usr/bin/aws" ### Specify the path to the AWS Command Line Interface executable. Run "which aws" command to get exact path.

# Private Link variables
vpc_id              = "vpc-005f5700386fcfa8d"
subnet_ids          = ["subnet-038bd7bd3b6221fa1","subnet-0116872432093824a","subnet-014c84cc7fe53c35b","subnet-0a02195494b703195","subnet-08b00a68c6cd343b2"]

vpc_endpoints = {
  # "e6data-s3" = {
  #   service_name = "com.amazonaws.us-east-1.s3"
  #   ingress_rules = []
  #   egress_rules  = []
  #   vpc_endpoint_type = "Gateway"
  # },
  "e6data-logs" = {
    service_name = "com.amazonaws.vpce.us-east-1.vpce-svc-0c0f5d925e9997e8a"
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
  },
  "e6data-metrics" = {
    service_name = "com.amazonaws.vpce.us-east-1.vpce-svc-052d956f02d5310da"
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
  },
    "e6data-ecr-dkr" = {
        service_name = "com.amazonaws.us-east-1.ecr.dkr"
        ingress_rules = []
        egress_rules  = []
        vpc_endpoint_type = "Interface"
    },
    "e6data-ecr-api" = {
        service_name = "com.amazonaws.us-east-1.ecr.api"
        ingress_rules = []
        egress_rules  = []
        vpc_endpoint_type = "Interface"
    }
}

allowed_principals  = ["arn:aws:iam::442042515899:root"] # e6data account whitlesiting to endpoint service

nginx_image_repository = "442042515899.dkr.ecr.us-east-1.amazonaws.com/nginx"  
nginx_image_tag        = "latest"

# Karpenter Variables
karpenter_namespace            = "kube-system" ### Namespace to deploy the karpenter
karpenter_service_account_name = "karpenter"   ### Service account name for the karpenter
karpenter_release_version      = "1.0.8"       ### Version of the karpenter Helm chart