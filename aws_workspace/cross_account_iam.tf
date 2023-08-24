data "aws_iam_policy_document" "iam_s3ReadWriteAccess_doc" {
  statement {
    sid = "ListBucket"
    actions = ["s3:ListBucket"]
    resources = [module.e6data_s3_bucket.arn]
  }

  statement {
    sid = "ReadWriteE6dataBucket"
    effect = "Allow"

    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:GetObjectTagging",
      "s3:GetObjectVersion",
      "s3:PutObjectTagging",
      "s3:DeleteObjectVersion",
      "s3:DeleteObject",
      "s3:DeleteObjectTagging",
      "s3:ListObjects"
    ]
    resources = ["${module.e6data_s3_bucket.arn}/*"]
  }
}

data "aws_iam_policy_document" "cross_account_iam_eksAccess_doc" {
  statement {
    sid = "describeEKSCluster" 
    effect = "Allow"
    
    actions = [
      "eks:DescribeCluster",
      "eks:ListNodegroups"  
    ]
    resources = [module.eks.eks_cluster_arn]
  }

  statement {
    sid = "descriEKSNodegroup" 
    effect = "Allow"
    
    actions = ["eks:DescribeNodegroup"]
    resources = [module.eks.eks_cluster_arn, aws_eks_node_group.workspace_node_group.arn]
  }
}

resource "aws_iam_policy" "e6data_s3_read_write_policy" {
  name        = "${local.e6data_workspace_name}-s3-readwrite-policy"
  description = "Allows read/write access for e6data workspace s3 bucket"
  policy      = data.aws_iam_policy_document.iam_s3ReadWriteAccess_doc.json
}

resource "aws_iam_policy" "e6data_cross_account_eks_policy" {
  name        = "${local.e6data_workspace_name}-cross-account-eks-policy"
  description = "Allows read access for EKS describe cluster"
  policy      = data.aws_iam_policy_document.cross_account_iam_eksAccess_doc.json
}

data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      identifiers = var.e6data_cross_oidc_role_arn
      type        = "AWS"
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [var.e6data_cross_account_external_id]
    }
  }
}

resource "aws_iam_role" "e6data_cross_account_role" {
  name = "${local.e6data_workspace_name}-cross-account-role"
  managed_policy_arns = [aws_iam_policy.e6data_s3_read_write_policy.arn, aws_iam_policy.e6data_cross_account_eks_policy.arn]
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}