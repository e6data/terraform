variable "aws_region" {
  type       = string
  description = "AWS region"
}

variable "kube_version" {
  type        = string
  description = "kubernetes master version"
}

variable "cluster_name" {
  type        = string
  description = "Name of kubernetes cluster"
}

variable "cluster_log_types" {
  type        = list(string)
  description = "EKS Cluster enabled log types to Cloudwatch"
  default     = ["scheduler", "controllerManager"]
}

variable "vpc_id" {
  type        = string
  description = "vpc id for e6data"
}

variable "private_subnet_ids" {
  type = list(string)
  description = "private subnet IDs"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet ids for eks cluster"
}

variable "min_size" {
  type        = number
  description = "EKS Worker nodes minimum nodes"
}

variable "desired_size" {
  type        = number
  description = "EKS Worker nodes desired count"
}

variable "max_size" {
  type        = number
  description = "EKS Worker nodes maximum nodes"
}

variable "disk_size" {
  type        = number
  description = "Disk size in GBs"
}

variable "instance_type" {
  type        = list(string)
  description = "EKS Worker node EC2 instance type"
  default     = ["t3.medium"]
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

variable "capacity_type" {
  type = string
  description = "Instance type to use in EKS : spot/on-demand"
  default = "SPOT"
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

variable "region" {
  type = string
  description = "region of the s3 gateway endpoint"
  default = "us-east-1"
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
