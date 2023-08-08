data "aws_iam_policy_document" "iam_eks_cluster_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "iam_eks_cluster_role" {
  name = "${var.cluster_name}-cluster-role"
  managed_policy_arns = var.iam_eks_cluster_policy_arn
  assume_role_policy = data.aws_iam_policy_document.iam_eks_cluster_assume_policy.json
}

data "aws_iam_policy_document" "iam_eks_node_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "iam_eks_node_role" {
  name = "${var.cluster_name}-node-role"
  managed_policy_arns = var.iam_eks_node_policy_arn
  assume_role_policy = data.aws_iam_policy_document.iam_eks_node_assume_policy.json
}
