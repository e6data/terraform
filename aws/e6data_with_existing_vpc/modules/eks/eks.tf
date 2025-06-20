terraform {
  required_providers {
    tls = {
      source  = "hashicorp/tls"
      version = "3.4.0"
    }
  }
}

# Create the EKS cluster
resource "aws_eks_cluster" "eks" {
  depends_on                = [aws_cloudwatch_log_group.eks]
  name                      = "e6data-${var.cluster_name}"
  role_arn                  = aws_iam_role.iam_eks_cluster_role.arn
  version                   = var.kube_version
  enabled_cluster_log_types = var.cluster_log_types

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_private_access = var.endpoint_private_access
    security_group_ids      = var.security_group_ids
  }

  access_config {
    authentication_mode = "API_AND_CONFIG_MAP"
  }
}

resource "aws_cloudwatch_log_group" "eks" {
  name              = "/aws/eks/e6data-${var.cluster_name}/cluster"
  retention_in_days = var.cloudwatch_log_retention_in_days
}