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

variable "eks_disk_size" {
  description = "disk size for the disks in nodepool"
  type        = number
}

variable "kubernetes_namespace" {
  description = "value of kubernetes namespace to deploy e6data workspace"
  type        = string
}

variable "cost_tags" {
  type        = map(string)
  description = "e6data specific tags for isaolation and cost management"
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

variable "excluded_az" {
  type        = list(string)
  description = "AZ where EKS doesnt have capacity"
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

variable "nodepool_instance_family" {
  type        = list(string)
  description = "Instance family for nodepool"
}

variable "nodepool_cpu_limits" {
  type        = number
  description = "CPU limits for nodepool"
  default     = 100000
}

variable "debug_namespaces" {
  type        = list(string)
  description = "kaprneter and alb controller namespaces"
  default     = ["kube-system"]
}

locals {
  cross_account_id = split(":", var.e6data_cross_oidc_role_arn[0])[4]
}