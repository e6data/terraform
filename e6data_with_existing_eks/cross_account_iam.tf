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

  depends_on = [ module.e6data_s3_bucket ]
}

data "aws_iam_policy_document" "cross_account_iam_eksAccess_doc" {
  statement {
    sid = "describeEKSCluster" 
    effect = "Allow"
    
    actions = [
      "eks:DescribeCluster",
      "eks:ListNodegroups"  
    ]
    resources = [data.aws_eks_cluster.current.arn]
  }

  statement {
    sid = "descriEKSNodegroup" 
    effect = "Allow"
    
    actions = ["eks:DescribeNodegroup"]
    resources = [
      data.aws_eks_cluster.current.arn,
      "arn:aws:eks:${var.aws_region}:${data.aws_caller_identity.current.account_id}:nodegroup/${var.eks_cluster_name}/*/*"
    ]
  }
}

data "aws_iam_policy_document" "connectivity_v2" {
  statement {
    sid       = "DescribeEC2ActionsandWAF2"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "ec2:CreateSecurityGroup",
      "ec2:DescribeRouteTables",
      "wafv2:GetWebACL",
      "wafv2:GetWebACLForResource",
      "wafv2:DisassociateWebACL",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeInstances",
      "servicequotas:GetServiceQuota"
    ]
  }

  statement {
    sid       = "CreateTagsForSecurityGroup"
    effect    = "Allow"
    resources = ["arn:aws:ec2:*:*:security-group/*"]
    actions   = ["ec2:CreateTags"]

    condition {
      test     = "StringEquals"
      variable = "ec2:CreateAction"
      values   = ["CreateSecurityGroup"]
    }

    condition {
      test     = "Null"
      variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
      values   = ["false"]
    }
  }

  statement {
    sid       = "ManageSecurityGroupTags"
    effect    = "Allow"
    resources = ["arn:aws:ec2:*:*:security-group/*"]

    actions = [
      "ec2:CreateTags",
      "ec2:DeleteTags",
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
    sid       = "DeleteSecurityGroup"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["ec2:DeleteSecurityGroup"]

    condition {
      test     = "Null"
      variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
      values   = ["false"]
    }
  }

  statement {
    sid       = "AllowSetWebACLforELB"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "elasticloadbalancing:SetWebACL",
      "elasticloadbalancing:DescribeLoadBalancers",
    ]
  }

  statement {
    sid       = "AllowCreateELB"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:DeleteLoadBalancer",
    ]

    condition {
      test     = "Null"
      variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
      values   = ["false"]
    }
  }

  statement {
    sid    = "AllowELBManagementtags"
    effect = "Allow"

    resources = [
      "arn:aws:elasticloadbalancing:*:*:listener/net/*/*",
      "arn:aws:elasticloadbalancing:*:*:listener/app/*/*",
      "arn:aws:elasticloadbalancing:*:*:listener-rule/net/*/*",
      "arn:aws:elasticloadbalancing:*:*:listener-rule/app/*/*",
    ]

    actions = [
      "elasticloadbalancing:AddTags",
      "elasticloadbalancing:RemoveTags",
    ]
  }

  statement {
    sid    = "AllowELBManagementtags2"
    effect = "Allow"

    resources = [
      "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
      "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*",
      "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
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
    sid    = ""
    effect = "Allow"

    resources = [
      "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
      "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
      "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*",
    ]

    actions = ["elasticloadbalancing:AddTags"]

    condition {
      test     = "StringEquals"
      variable = "elasticloadbalancing:CreateAction"

      values = [
        "CreateTargetGroup",
        "CreateLoadBalancer",
      ]
    }

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

resource "aws_iam_policy" "e6data_connectivity_v2_policy" {
  name        = "${local.e6data_workspace_name}-connectivity-v2-policy"
  description = "Allows load balancer and WAF2 related permissions required for connectivity_v2"
  policy      = data.aws_iam_policy_document.connectivity_v2.json
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
  managed_policy_arns = [aws_iam_policy.e6data_s3_read_write_policy.arn, aws_iam_policy.e6data_cross_account_eks_policy.arn, aws_iam_policy.e6data_connectivity_v2_policy.arn]
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
}