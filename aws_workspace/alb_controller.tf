data "aws_iam_policy_document" "alb_controller_access_doc" {
  statement {
    actions = [
      "iam:CreateServiceLinkedRole"
   ]
    resources = ["*"]
    condition {
      test    = "StringEquals"
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
        "ec2:GetCoipPoolUsage",
        "ec2:DescribeCoipPools",
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
        "cognito-idp:DescribeUserPoolClient",
        "acm:ListCertificates",
        "acm:DescribeCertificate",
        "iam:ListServerCertificates",
        "iam:GetServerCertificate",
        "waf-regional:GetWebACL",
        "waf-regional:GetWebACLForResource",
        "waf-regional:AssociateWebACL",
        "waf-regional:DisassociateWebACL",
        "wafv2:GetWebACL",
        "wafv2:GetWebACLForResource",
        "wafv2:AssociateWebACL",
        "wafv2:DisassociateWebACL",
        "shield:GetSubscriptionState",
        "shield:DescribeProtection",
        "shield:CreateProtection",
        "shield:DeleteProtection"
    ]
    resources = ["*"]
  }

  statement {
    actions = [ 
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:RevokeSecurityGroupIngress"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
        "ec2:CreateSecurityGroup",
        "ec2:DeleteSecurityGroup"
    ]
    resources = ["*"]
  }

  statement {
    actions = [
        "ec2:CreateTags"
    ]
    resources = ["arn:aws:ec2:*:*:security-group/*"]
    condition {
      test = "StringEquals"
      variable = "ec2:CreateAction"
      values = ["CreateSecurityGroup"]
    }
    condition {
        test = "Null"
        variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
        values = ["false"]
    }
  }

  statement {
    actions =[
        "ec2:CreateTags",
        "ec2:DeleteTags"
    ]
    resources = ["arn:aws:ec2:*:*:security-group/*"]
    condition {
      test = "Null"
      variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
      values = ["true"]
    }

    condition {
      test = "Null"
      variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
      values = ["false"]
    }
  }

  statement {
    actions = [
        "ec2:AuthorizeSecurityGroupIngress",
        "ec2:RevokeSecurityGroupIngress",
        "ec2:DeleteSecurityGroup"
    ]
    resources = ["*"]
    condition {
      test = "StringEquals"
      variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
      values = ["true"]
    }
  }

  statement {
    actions = [
        "elasticloadbalancing:CreateLoadBalancer",
        "elasticloadbalancing:CreateTargetGroup"
    ]
    resources = ["*"]
    condition {
        test = "Null"
        variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
        values = ["false"]
    }
  }

  statement {
    actions = [
        "elasticloadbalancing:AddTags",
        "elasticloadbalancing:RemoveTags"
    ]
    resources = [
        "arn:aws:elasticloadbalancing:*:*:loadbalancer/net/*/*",
        "arn:aws:elasticloadbalancing:*:*:loadbalancer/app/*/*", 
        "arn:aws:elasticloadbalancing:*:*:targetgroup/*/*"
    ]
    condition {
        test = "Null"
        variable = "aws:RequestTag/elbv2.k8s.aws/cluster"
        values = ["true"]
    }
    condition {
        test = "Null"
        variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
        values = ["false"]
    }
  }

  statement {
    actions = [
        "elasticloadbalancing:CreateListener",
        "elasticloadbalancing:DeleteListener",
        "elasticloadbalancing:CreateRule",
        "elasticloadbalancing:DeleteRule"
    ]
    resources = ["*"]
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
        test = "Null"
        variable = "aws:ResourceTag/elbv2.k8s.aws/cluster"
        values = ["false"]
    }
  }

  statement {
    actions = [
        "elasticloadbalancing:AddTags",
        "elasticloadbalancing:RemoveTags"
    ]
    resources = [
        "arn:aws:elasticloadbalancing:*:*:listener/net/*/*",
        "arn:aws:elasticloadbalancing:*:*:listener/app/*/*", 
        "arn:aws:elasticloadbalancing:*:*:listener-rule/net/*/*",
        "arn:aws:elasticloadbalancing:*:*:listener-rule/app/*/*", 
    ]
  }
  
  statement {
    actions = [
        "elasticloadbalancing:RegisterTargets",
        "elasticloadbalancing:DeregisterTargets"
    ]
    resources = ["arn:aws:elasticloadbalancing:*:*:targetgroup/*/*"]
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
  }
}

resource "aws_iam_policy" "alb_controller_policy" {
  name = "e6data-${module.eks.cluster_name}-alb-controller-policy"
  description = "EKS cluster ALB controller policy for cluster ${module.eks.cluster_name}"
  policy      = data.aws_iam_policy_document.alb_controller_access_doc.json
}

module "alb_controller_oidc" {
  source = "./modules/aws_oidc"

  providers = {
    kubernetes = kubernetes.eks_e6data
  }

  tls_url = module.eks.eks_oidc_tls
  policy_arn = [aws_iam_policy.alb_controller_policy.arn]
  eks_oidc_arn = module.eks.oidc_arn

  oidc_role_name = "${module.eks.cluster_name}-alb-controller"

  kubernetes_namespace = var.alb_ingress_controller_namespace
  kubernetes_service_account_name = var.alb_ingress_controller_service_account_name
}

resource "aws_ec2_tag" "subnet_cluster_tag" {
  count    =    length(module.network.public_subnet_ids)
  resource_id = module.network.public_subnet_ids[count.index]
  key         = "kubernetes.io/role/elb"
  value       = "1"
}

data "aws_elb_service_account" "main" {}

module "aws_ingress_controller" {
  source = "./modules/alb_controller"

  providers = {
    kubernetes = kubernetes.e6data
    helm       = helm.e6data
  }

  eks_cluster_name = module.eks.cluster_name

  eks_service_account_name = module.alb_controller_oidc.service_account_name
  namespace = module.alb_controller_oidc.kubernetes_namespace
  alb_ingress_controller_version = var.alb_controller_helm_chart_version # "1.4.7"

  depends_on = [ module.alb_controller_oidc, module.autoscaler_deployment, aws_eks_node_group.workspace_node_group]
}
