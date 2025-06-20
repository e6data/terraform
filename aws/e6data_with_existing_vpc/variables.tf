variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "kube_version" {
  type        = string
  description = "kubernetes master version"
}

variable "default_nodegroup_kube_version" {
  type        = string
  description = "kubernetes worker version"
}

variable "helm_chart_version" {
  description = "Version of e6data workspace helm chart to deploy"
  type        = string
}

variable "cluster_name" {
  type        = string
  description = "Name of kubernetes cluster"
}

variable "cluster_log_types" {
  type        = list(string)
  description = "EKS Cluster enabled log types to Cloudwatch"
  default     = ["scheduler", "controllerManager", "authenticator", "audit"]
}

variable "cloudwatch_log_retention_in_days" {
  description = "cloudwatch log retention period"
  type        = number
  default     = 30
}

variable "vpc_id" {
  type        = string
  description = "VPC ID to create e6data resources"
}

variable "app" {
  type        = string
  description = "tag prefix to be added"
  default     = "e6data"
}

variable "aws_command_line_path" {
  description = "local aws installation bin path"
  type        = string
}

variable "workspace_name" {
  description = "Name of e6data workspace to be created"
  type        = string
}

variable "eks_nodegroup_iam_policy_arn" {
  type        = list(string)
  description = "List of Policies to attach to the EKS node role"
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

  ]
}

variable "eks_disk_size" {
  description = "disk size for the disks in node pool"
  type        = number
}

variable "eks_capacity_type" {
  description = "Instance lifecycle for e6data nodegroup"
  type        = string
  default     = "ON_DEMAND"
}

variable "kubernetes_namespace" {
  description = "value of kubernetes namespace to deploy e6data workspace"
  type        = string
}

variable "e6data_cross_oidc_role_arn" {
  type        = list(string)
  description = "ARN of the cross account role to assume"
  default     = ["arn:aws:iam::442042515899:root"]
}

variable "e6data_cross_account_external_id" {
  type        = string
  description = "External ID of the cross account role to assume"
  default     = "783562"
}

# ALB Ingress Controller variables
variable "alb_ingress_controller_namespace" {
  type        = string
  description = "ALB Ingress Controller namespace"
}

variable "alb_ingress_controller_service_account_name" {
  type        = string
  description = "ALB Ingress Controller service account name"
}

variable "alb_controller_helm_chart_version" {
  type        = string
  description = "ALB Ingress Controller helm chart version"
}

variable "public_access_cidrs" {
  type        = list(string)
  description = "public access cidrs"
  default     = ["44.194.151.209/32"]
}

variable "endpoint_private_access" {
  type        = bool
  default     = true
  description = "To enable private access to the eks cluster"
}

variable "endpoint_public_access" {
  type        = bool
  default     = false
  description = "To enable public access to the eks cluster"
}

### Karpenter Variables
variable "karpenter_eks_node_policy_arn" {
  type        = list(string)
  description = "List of Policies to attach to the Karpenter node role"
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}

variable "karpenter_namespace" {
  description = "Namespace to deploy the Karpenter cluster autoscaler"
  type        = string
}

variable "karpenter_service_account_name" {
  description = "Service account name for the Karpenter cluster autoscaler"
  type        = string
}

variable "karpenter_release_version" {
  description = "Version of the Karpenter cluster autoscaler Helm chart"
  type        = string
}

variable "nodepool_instance_family" {
  type        = list(string)
  description = "Instance family for nodepool"
}

variable "nodepool_cpu_limits" {
  type        = number
  description = "CPU limits for nodepool"
  default     = 100000
}

## EKS Security Group
variable "ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    self        = bool
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "-1"
      self        = true
      cidr_blocks = []
    }
  ]
}

variable "egress_rules" {
  description = "List of egress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    self        = bool
    cidr_blocks = list(string)
  }))
  default = [
    {
      from_port       = 53
      to_port         = 53
      protocol        = "udp"
      self            = true
      cidr_blocks     = []
      security_groups = []
    },
    {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      self        = false
      cidr_blocks = ["0.0.0.0/0"]
    },
    {
      from_port   = 0
      to_port     = 65535
      protocol    = "tcp"
      self        = true
      cidr_blocks = []
    }
  ]
}

variable "additional_ingress_rules" {
  description = "List of additional ingress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    self        = bool
    cidr_blocks = list(string)
  }))
  default = []
}

variable "additional_egress_rules" {
  description = "List of additional egress rules"
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    self        = bool
    cidr_blocks = list(string)
  }))
  default = []
}

variable "debug_namespaces" {
  type        = list(string)
  description = "karpenter and alb controller namespaces"
  default     = ["kube-system"]
}

variable "warm_eni_target" {
  description = "Number of extra ENIs (Elastic Network Interfaces) to keep available for pod assignment."
  type        = number
  default     = 0
}

variable "warm_prefix_target" {
  description = "Number of extra IP address prefixes to keep available for pod assignment."
  type        = number
  default     = 0
}

variable "minimum_ip_target" {
  description = "Minimum number of IP addresses to keep available for pod assignment."
  type        = number
  default     = 12
}

locals {
  cross_account_id = split(":", var.e6data_cross_oidc_role_arn[0])[4]
}

variable "e6data_engine_role_arn" {
  description = "IAM role ARN for the e6data engine to read buckets"
  type        = string
  
}


## Private Link Variables
variable "cost_tags" {
  type = map(string)
  description = "cost tags"
}

variable "allowed_principals" {
  type = list(string)
}

variable "nginx_image_repository" {
  description = "Container image repository for nginx"
}

variable "nginx_image_tag" {
  description = "Container image tag for nginx"
}

variable "nameOverride" {
  type = string
  default = "kube-api-proxy"
}

variable "interface_vpc_endpoints" {
  description = "Map of VPC Interface endpoints to create"
}   