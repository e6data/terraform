terraform {
    required_providers {
        tls = {
            source = "hashicorp/tls"
            version = "3.4.0"
        }
    }
}

# Create the EKS cluster
resource "aws_eks_cluster" "eks" {
  name     = "e6data-${var.cluster_name}"
  role_arn = aws_iam_role.iam_eks_cluster_role.arn
  version  = var.kube_version
  enabled_cluster_log_types = var.cluster_log_types

  vpc_config {
    subnet_ids         = var.subnet_ids
  }
}
