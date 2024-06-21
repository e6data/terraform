data "aws_iam_policy_document" "iam_s3ReadWriteAccess_doc" {
  statement {
    sid       = "ListBucket"
    actions   = ["s3:ListBucket"]
    resources = [module.e6data_s3_bucket.arn]
  }

  statement {
    sid    = "ReadWriteE6dataBucket"
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
    sid    = "describeEKSCluster"
    effect = "Allow"

    actions = [
      "eks:DescribeCluster",
      "eks:ListNodegroups"
    ]
    resources = [module.eks.eks_cluster_arn]
  }

  statement {
    sid    = "descriEKSNodegroup"
    effect = "Allow"

    actions = ["eks:DescribeNodegroup"]
    resources = [
      module.eks.eks_cluster_arn,
      "arn:aws:eks:${var.aws_region}:${data.aws_caller_identity.current.account_id}:nodegroup/${module.eks.cluster_name}/*/*"
    ]
  }

  statement {
    sid    = "PermissionsForAllResources"
    effect = "Allow"

    actions = [
      "ec2:DescribeRouteTables",
      "acm:DescribeCertificate",
      "elasticloadbalancing:DescribeLoadBalancers",
      "wafv2:GetWebACL",
      "wafv2:GetWebACLForResource",
      "ec2:DescribeInstances",
      "servicequotas:GetServiceQuota",
      "cloudwatch:GetMetricStatistics"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "AllowSetWebACLforELB"
    effect = "Allow"
    actions = [
      "elasticloadbalancing:SetWebACL",
      "wafv2:DisassociateWebACL"
    ]
    resources = ["arn:aws:elasticloadbalancing:${var.aws_region}:${data.aws_caller_identity.current.account_id}:loadbalancer/app/e6data-*/*"]
  }

  statement {
    sid       = "AllowCreateELB"
    effect    = "Allow"
    actions   = ["elasticloadbalancing:CreateLoadBalancer"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/app"
      values   = ["e6data"]
    }
  }

  statement {
    sid       = "AllowDeleteELB"
    effect    = "Allow"
    actions   = ["elasticloadbalancing:DeleteLoadBalancer"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/app"
      values   = ["e6data"]
    }
  }

  statement {
    sid    = "ManageELBTags"
    effect = "Allow"
    actions = [
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:RemoveTags"
    ]

    resources = [
      "arn:aws:elasticloadbalancing:${var.aws_region}:${data.aws_caller_identity.current.account_id}:listener/net/e6data-*/*",
      "arn:aws:elasticloadbalancing:${var.aws_region}:${data.aws_caller_identity.current.account_id}:listener/app/e6data-*/*",
      "arn:aws:elasticloadbalancing:${var.aws_region}:${data.aws_caller_identity.current.account_id}:listener-rule/net/e6data-*/*",
      "arn:aws:elasticloadbalancing:${var.aws_region}:${data.aws_caller_identity.current.account_id}:listener-rule/app/e6data-*/*"
    ]
  }

  statement {
    sid    = "manageELBTargetGroupTags"
    effect = "Allow"

    resources = [
      "arn:aws:elasticloadbalancing:${var.aws_region}:${data.aws_caller_identity.current.account_id}:loadbalancer/net/e6data-*/*",
      "arn:aws:elasticloadbalancing:${var.aws_region}:${data.aws_caller_identity.current.account_id}:loadbalancer/app/e6data-*/*",
      "arn:aws:elasticloadbalancing:${var.aws_region}:${data.aws_caller_identity.current.account_id}:targetgroup/e6data-*/*"
    ]

    actions = [
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:RemoveTags",
    ]

    condition {
      test     = "Null"
      variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
      values   = ["true"]
    }

    condition {
      test     = "Null"
      variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
      values   = ["false"]
    }
  }

  statement {
    sid    = "ALBIngressControllerTags"
    effect = "Allow"

    resources = [
      "arn:aws:elasticloadbalancing:${var.aws_region}:${data.aws_caller_identity.current.account_id}:targetgroup/e6data-*/*",
      "arn:aws:elasticloadbalancing:${var.aws_region}:${data.aws_caller_identity.current.account_id}:loadbalancer/net/e6data-*/*",
      "arn:aws:elasticloadbalancing:${var.aws_region}:${data.aws_caller_identity.current.account_id}:loadbalancer/app/e6data-*/*"
    ]

    actions = ["elasticloadbalancing:AddTags"]

    condition {
      test     = "Null"
      variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
      values   = ["false"]
    }
  }

  statement {
    sid       = "AllowWAFv2WebACLAndIPSetCreation"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "wafv2:CreateWebACL",
      "wafv2:CreateIPSet",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/app"
      values   = ["e6data"]
    }
  }

  statement {
    sid       = "AllowWAFv2WebACLManagement"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "wafv2:TagResource",
      "wafv2:AssociateWebACL",
      "wafv2:DeleteWebACL",
      "wafv2:UpdateWebACL",
      "wafv2:GetIPSet",
      "wafv2:CreateIPSet",
      "wafv2:DeleteIPSet",
      "wafv2:UpdateIPSet",
      "wafv2:UntagResource",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/app"
      values   = ["e6data"]
    }
  }
}

resource "aws_iam_policy" "e6data_s3_read_write_policy" {
  name        = "${local.e6data_workspace_name}-s3-readwrite-${random_string.random.result}"
  description = "Allows read/write access for e6data workspace s3 bucket"
  policy      = data.aws_iam_policy_document.iam_s3ReadWriteAccess_doc.json
}

resource "aws_iam_policy" "e6data_cross_account_eks_policy" {
  name        = "${local.e6data_workspace_name}-cross-account-eks-${random_string.random.result}"
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
  name                = "${local.e6data_workspace_name}-cross-account-role-${random_string.random.result}"
  managed_policy_arns = [aws_iam_policy.e6data_s3_read_write_policy.arn, aws_iam_policy.e6data_cross_account_eks_policy.arn]
  assume_role_policy  = data.aws_iam_policy_document.assume_role_policy.json
}
