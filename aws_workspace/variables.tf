variable "aws_region" {
  type       = string
  description = "AWS region"
}

variable "kube_version" {
  type        = string
  description = "kubernetes master version"
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

variable "cidr_block" {
  type        = string
  description = "Base CIDR block which will be divided into subnet CIDR blocks (e.g. `10.0.0.0/16`)"
}

variable "excluded_az" {
  type        = list(string)
  description = "AZ where EKS doesnt have capacity"
}

variable "iam_eks_cluster_policy_arn" {
  type        = list(string)
  description = "List of Policies to attach to the EKS cluster role"
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  ]
}

variable "iam_eks_node_policy_arn" {
  type        = list(string)
  description = "List of Policies to attach to the EKS node role"
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryFullAccess",
    "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientFullAccess"
  ]
}

variable "cost_tags" {
  type = map(string)
  description = "cost tags"
}

variable "app" {
  type        = string
  description = "tag prefix to be added"
  default = "e6data"
}

variable "aws_command_line_path" {
  description = "local aws installation bin path"
  type        = string
}

# Autoscaler variables
variable "autoscaler_namespace" {
  type        = string
  description = "Autoscaler namespace"
}

variable "autoscaler_service_account_name" {
  type        = string
  description = "Autoscaler service account name"
}

variable "autoscaler_helm_chart_name" {
  type        = string
  description = "Autoscaler helm chart name"
}

variable "autoscaler_helm_chart_version" {
  type        = string
  description = "Autoscaler helm chart version"
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
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy",
    "arn:aws:iam::aws:policy/AmazonElasticFileSystemClientFullAccess"
  ]
}


variable "eks_disk_size" {
  description = "disk size for the disks in node group"
  type        = number
}

variable "eks_capacity_type" {
  description = "Instance lifecycle for e6data nodegroup"
  type        = string
}

variable "eks_nodegroup_instance_types" {
  description = "Instance type for nodegroup"
  type        = list(string)
  default = ["c7g.16xlarge"]
}

variable "max_instances_in_eks_nodegroup" {
  description = "Maximum number of instances in nodegroup"
  type        = number
}

variable "min_desired_instances_in_eks_nodegroup" {
  description = "Minimum number of instances in nodegroup"
  type        = number
  default     = 1
}

variable "kubernetes_namespace" {
  description = "value of kubernetes namespace to deploy e6data workspace"
  type        = string
}

variable "e6data_cross_oidc_role_arn" {
  type        = list(string)
  description = "ARN of the cross account role to assume"
  default = [ "arn:aws:iam::298655976287:root" ]
}

variable "bucket_names" {
  type        = list(string)
  description = "List of bucket names to be queried by e6data engine"
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

variable "internal_lb_enabled" {
  type        = bool
  description = "Internal Load Balancer enabled"
}