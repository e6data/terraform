variable "workspace_name" {
  description = "Name of e6data workspace to be created"
  type        = string
}

variable "aws_region" {
  description = "AWS region to run e6data workspace"
  type        = string
}

variable "eks_cluster_name" {
  description = "Kubernetes cluster name"
  type        = string
}

variable "kube_version" {
  type        = string
  description = "kubernetes master version"
}

variable "eks_nodegroup_iam_policy_arn" {
  type        = list(string)
  description = "List of Policies to attach to the EKS node role"
  default = [
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy",
    "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  ]
}

variable "eks_disk_size" {
  description = "disk size for the disks in node group"
  type        = number
}

variable "eks_capacity_type" {
  description = "Instance lifecycle for e6data nodegroup"
  type        = string
  default     = "ON_DEMAND"
}

variable "eks_nodegroup_instance_types" {
  description = "Instance type for nodegroup"
  type        = list(string)
  default = ["r7g.8xlarge","r7g.12xlarge","r7g.16xlarge", "r6g.8xlarge","r6g.12xlarge","r6g.16xlarge"]
}

variable "max_instances_in_eks_nodegroup" {
  description = "Maximum number of instances in nodegroup"
  type        = number
}

variable "min_instances_in_eks_nodegroup" {
  description = "Minimum number of instances in nodegroup"
  type        = number
  default     = 0
}

variable "desired_instances_in_eks_nodegroup" {
  description = "Minimum number of instances in nodegroup"
  type        = number
  default     = 0
}

variable "kubernetes_namespace" {
  description = "value of kubernetes namespace to deploy e6data workspace"
  type        = string
}

variable "cost_tags" {
  type = map(string)
  description = "e6data specific tags for isaolation and cost management"
}

variable "e6data_cross_oidc_role_arn" {
  type        = list(string)
  description = "ARN of the cross account role to assume"
  default = [ "arn:aws:iam::298655976287:root" ]
}

variable "e6data_cross_account_external_id" {
  type        = string
  description = "External ID of the cross account role to assume"
  default = "783562"
}

variable "bucket_names" {
  type        = list(string)
  description = "List of bucket names to be queried by e6data engine"
}

variable "helm_chart_version" {
  description = "Version of e6data workspace helm chart to deploy"
  type        = string
}

variable "aws_command_line_path" {
  description = "local aws installation bin path"
  type        = string
}
