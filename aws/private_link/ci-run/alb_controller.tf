data "aws_iam_policy_document" "alb_controller_access_doc" {
  statement {
    actions = [
      "iam:CreateServiceLinkedRole"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "iam:AWSServiceName"
      values   = ["elasticloadbalancing.amazonaws.com"]
    }
  }

  statement {
    actions = [
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeAddresses",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeInternetGateways",
      "ec2:DescribeVpcs",
      "ec2:DescribeVpcPeeringConnections",
      "ec2:DescribeSubnets",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeInstances",
      "ec2:DescribeNetworkInterfaces",
      "ec2:DescribeTags",
      "elasticloadbalancing:DescribeLoadBalancers",
      "elasticloadbalancing:DescribeLoadBalancerAttributes",
      "elasticloadbalancing:DescribeListeners",
      "elasticloadbalancing:DescribeListenerCertificates",
      "elasticloadbalancing:DescribeSSLPolicies",
      "elasticloadbalancing:DescribeRules",
      "elasticloadbalancing:DescribeTargetGroups",
      "elasticloadbalancing:DescribeTargetGroupAttributes",
      "elasticloadbalancing:DescribeTargetHealth",
      "elasticloadbalancing:DescribeTags"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "acm:ListCertificates",
      "acm:DescribeCertificate",
      # "iam:ListServerCertificates",
      # "iam:GetServerCertificate",
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "ec2:CreateSecurityGroup"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "ec2:AuthorizeSecurityGroupIngress",
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/app"
      values   = ["e6data"]
    }
  }

  statement {
    actions = [
      "ec2:DeleteSecurityGroup"
    ]
    resources = ["arn:aws:ec2:*:*:security-group/*"]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/app"
      values   = ["e6data"]
    }
  }

  statement {
    actions = [
      "ec2:CreateTags"
    ]
    resources = ["arn:aws:ec2:*:*:security-group/*"]
    condition {
      test     = "StringEquals"
      variable = "ec2:CreateAction"
      values   = ["CreateSecurityGroup"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/app"
      values   = ["e6data"]
    }
  }

  statement {
    actions = [
      "ec2:CreateTags"
    ]
    resources = ["arn:aws:ec2:*:*:security-group/*"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/app"
      values   = ["e6data"]
    }
  }

  statement {
    actions = [
      "ec2:DeleteTags"
    ]
    resources = ["arn:aws:ec2:*:*:security-group/*"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/app"
      values   = ["e6data"]
    }
  }

  statement {
    actions = [
      "ec2:RevokeSecurityGroupIngress"
    ]
    resources = ["*"]
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/app"
      values   = ["e6data"]
    }
  }

  statement {
    actions = [
      "elasticloadbalancing:CreateLoadBalancer",
      "elasticloadbalancing:CreateTargetGroup"
    ]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/app"
      values   = ["e6data"]
    }
  }

  statement {
    actions = [
      "elasticloadbalancing:RemoveTags"
    ]
    resources = [
      "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
      "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*",
      "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/app"
      values   = ["e6data"]
    }
  }

  statement {
    actions = [
      "elasticloadbalancing:CreateListener",
      "elasticloadbalancing:CreateRule"
    ]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/app"
      values   = ["e6data"]
    }
  }

  statement {
    actions = [
      "elasticloadbalancing:DeleteListener",
      "elasticloadbalancing:DeleteRule"
    ]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/app"
      values   = ["e6data"]
    }
  }

  statement {
    actions = [
      "elasticloadbalancing:SetIpAddressType",
      "elasticloadbalancing:SetSecurityGroups",
      "elasticloadbalancing:SetSubnets",
      "elasticloadbalancing:DeleteLoadBalancer",
      "elasticloadbalancing:ModifyLoadBalancerAttributes",
      "elasticloadbalancing:ModifyTargetGroup",
      "elasticloadbalancing:ModifyTargetGroupAttributes",
      "elasticloadbalancing:DeleteTargetGroup"
    ]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/app"
      values   = ["e6data"]
    }
  }

  statement {
    actions = [
      "elasticloadbalancing:AddTags"
    ]
    resources = [
      "arn:aws:elasticloadbalancing:*:*:listener/net/*/*",
      "arn:aws:elasticloadbalancing:*:*:listener/app/*/*",
      "arn:aws:elasticloadbalancing:*:*:listener-rule/net/*/*",
      "arn:aws:elasticloadbalancing:*:*:listener-rule/app/*/*",
      "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
      "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
      "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/app"
      values   = ["e6data"]
    }
  }

  statement {
    actions = [
      "elasticloadbalancing:AddTags"
    ]
    resources = [
      "arn:aws:elasticloadbalancing:*:*:listener/net/*/*",
      "arn:aws:elasticloadbalancing:*:*:listener/app/*/*",
      "arn:aws:elasticloadbalancing:*:*:listener-rule/net/*/*",
      "arn:aws:elasticloadbalancing:*:*:listener-rule/app/*/*",
      "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
      "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
      "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/app"
      values   = ["e6data"]
    }
  }

  statement {
    actions = [
      "elasticloadbalancing:RemoveTags"
    ]
    resources = [
      "arn:aws:elasticloadbalancing:*:*:listener/net/*/*",
      "arn:aws:elasticloadbalancing:*:*:listener/app/*/*",
      "arn:aws:elasticloadbalancing:*:*:listener-rule/net/*/*",
      "arn:aws:elasticloadbalancing:*:*:listener-rule/app/*/*",
      "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*",
      "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
      "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/app"
      values   = ["e6data"]
    }
  }

  statement {
    actions = [
      "elasticloadbalancing:RegisterTargets",
      "elasticloadbalancing:DeregisterTargets"
    ]
    resources = ["arn:aws:elasticloadbalancing:*:*:targetgroup/*/*"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/app"
      values   = ["e6data"]
    }
  }

  statement {
    actions = [
      "elasticloadbalancing:SetWebAcl",
      "elasticloadbalancing:ModifyListener",
      "elasticloadbalancing:AddListenerCertificates",
      "elasticloadbalancing:RemoveListenerCertificates",
      "elasticloadbalancing:ModifyRule"
    ]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/app"
      values   = ["e6data"]
    }

  }
}

resource "aws_iam_policy" "alb_controller_policy" {
  name        = "${module.eks.cluster_name}-alb-controller-policy-${random_string.random.result}"
  description = "EKS cluster ALB controller policy for cluster ${module.eks.cluster_name}"
  policy      = data.aws_iam_policy_document.alb_controller_access_doc.json
}

# Configure the OIDC provider for the AWS ALB Ingress Controller to enable integration with EKS
module "alb_controller_oidc" {
  source = "./modules/aws_oidc"

  tls_url      = module.eks.eks_oidc_tls
  policy_arn   = [aws_iam_policy.alb_controller_policy.arn]
  eks_oidc_arn = module.eks.oidc_arn

  oidc_role_name = "${module.eks.cluster_name}-alb-controller"

  kubernetes_namespace            = var.alb_ingress_controller_namespace
  kubernetes_service_account_name = var.alb_ingress_controller_service_account_name

  depends_on = [module.eks, module.e6data_authentication]
}

resource "aws_ec2_tag" "private_subnet_cluster_tag" {
  count       = length(module.network.private_subnet_ids)
  resource_id = module.network.private_subnet_ids[count.index]
  key         = "kubernetes.io/role/internal-elb"
  value       = "1"
}
