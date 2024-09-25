# This resource adds a tag to each subnet in the network module
# to enable Karpenter to discover the EKS cluster.
resource "aws_ec2_tag" "karpenter_subnet_cluster_tag" {
  count       = var.additional_cidr_block == "" ? length(module.network.private_subnet_ids) : 0
  resource_id = module.network.private_subnet_ids[count.index]
  key         = "karpenter.sh/discovery"
  value       = module.eks.cluster_name
}

resource "aws_ec2_tag" "karpenter_subnet_cluster_tag_additional" {
  count       = var.additional_cidr_block == "" ? 0 : length(module.network.additional_private_subnet_ids)
  resource_id = module.network.additional_private_subnet_ids[count.index]
  key         = "karpenter.sh/discovery"
  value       = module.eks.cluster_name
}

data "aws_iam_policy_document" "karpenter_node_trust_policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

##The karpenter node role includes several AWS managed policies, which are designed to provide permissions for specific uses needed by the nodes to work with EC2 and other AWS resources.
resource "aws_iam_role" "karpenter_node_role" {
  name                = "e6data-${var.cluster_name}-KarpenterNodeRole-${random_string.random.result}"
  managed_policy_arns = var.karpenter_eks_node_policy_arn
  assume_role_policy  = data.aws_iam_policy_document.karpenter_node_trust_policy.json
}

# Grants Karpenter controller scoped permissions to manage EC2 resources, including creation, tagging, and deletion, with conditions to limit actions to specific cluster and nodepool tags.
data "aws_iam_policy_document" "karpenter_controller_policy_document" {
  statement {
    actions = [
      "ec2:RunInstances",
      "ec2:CreateFleet"
    ]
    sid    = "AllowScopedEC2InstanceAccessActions"
    effect = "Allow"
    resources = [
      "arn:aws:ec2:${var.aws_region}::image/*",
      "arn:aws:ec2:${var.aws_region}::snapshot/*",
      "arn:aws:ec2:${var.aws_region}:*:security-group/*",
      "arn:aws:ec2:${var.aws_region}:*:subnet/*"
    ]
  }

  statement {
    actions = [
      "ec2:RunInstances",
      "ec2:CreateFleet"
    ]

    effect    = "Allow"
    resources = ["arn:aws:ec2:${var.aws_region}:*:launch-template/*"]
    sid       = "AllowScopedEC2LaunchTemplateAccessActions"
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/kubernetes.io/cluster/${module.eks.cluster_name}"
      values   = ["owned"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/karpenter.sh/nodepool"
      values   = [local.e6data_nodepool_name]
    }
  }

  statement {
    actions = [
      "ec2:RunInstances",
      "ec2:CreateFleet",
      "ec2:CreateLaunchTemplate"
    ]

    effect = "Allow"
    resources = [
      "arn:aws:ec2:${var.aws_region}:*:fleet/*",
      "arn:aws:ec2:${var.aws_region}:*:instance/*",
      "arn:aws:ec2:${var.aws_region}:*:volume/*",
      "arn:aws:ec2:${var.aws_region}:*:network-interface/*",
      "arn:aws:ec2:${var.aws_region}:*:launch-template/*",
      "arn:aws:ec2:${var.aws_region}:*:spot-instances-request/*"
    ]

    sid = "AllowScopedEC2InstanceActionsWithTags"
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes.io/cluster/${module.eks.cluster_name}"
      values   = ["owned"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/karpenter.sh/nodepool"
      values   = [local.e6data_nodepool_name]
    }
  }

  statement {
    actions = [
      "ec2:CreateTags"
    ]

    effect = "Allow"
    resources = [
      "arn:aws:ec2:${var.aws_region}:*:fleet/*",
      "arn:aws:ec2:${var.aws_region}:*:instance/*",
      "arn:aws:ec2:${var.aws_region}:*:volume/*",
      "arn:aws:ec2:${var.aws_region}:*:network-interface/*",
      "arn:aws:ec2:${var.aws_region}:*:launch-template/*",
      "arn:aws:ec2:${var.aws_region}:*:spot-instances-request/*"
    ]

    sid = "AllowScopedResourceCreationTagging"
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes.io/cluster/${module.eks.cluster_name}"
      values   = ["owned"]
    }
    condition {
      test     = "StringEquals"
      variable = "ec2:CreateAction"
      values = [
        "RunInstances",
        "CreateFleet",
        "CreateLaunchTemplate"
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/karpenter.sh/nodepool"
      values   = [local.e6data_nodepool_name]
    }
  }

  statement {
    actions = [
      "ec2:CreateTags"
    ]

    effect = "Allow"
    resources = [
      "arn:aws:ec2:${var.aws_region}:*:instance/*"
    ]

    sid = "AllowScopedResourceTagging"
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/kubernetes.io/cluster/${module.eks.cluster_name}"
      values   = ["owned"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/karpenter.sh/nodepool"
      values   = [local.e6data_nodepool_name]
    }
  }

  statement {
    actions = [
      "ec2:TerminateInstances",
      "ec2:DeleteLaunchTemplate"
    ]

    effect = "Allow"
    resources = [
      "arn:aws:ec2:${var.aws_region}:*:instance/*",
      "arn:aws:ec2:${var.aws_region}:*:launch-template/*"
    ]

    sid = "AllowScopedDeletion"
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/kubernetes.io/cluster/${module.eks.cluster_name}"
      values   = ["owned"]
    }
    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/karpenter.sh/nodepool"
      values   = [local.e6data_nodepool_name]
    }
  }

  statement {
    actions = [
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeImages",
      "ec2:DescribeInstances",
      "ec2:DescribeInstanceTypeOfferings",
      "ec2:DescribeInstanceTypes",
      "ec2:DescribeLaunchTemplates",
      "ec2:DescribeSecurityGroups",
      "ec2:DescribeSpotPriceHistory",
      "ec2:DescribeSubnets"
    ]

    effect    = "Allow"
    resources = ["*"]

    sid = "AllowRegionalReadActions"
    condition {
      test     = "StringEquals"
      variable = "aws:RequestedRegion"
      values   = ["${var.aws_region}"]
    }
  }

  statement {
    actions = [
      "ssm:GetParameter"
    ]

    effect    = "Allow"
    resources = ["arn:aws:ssm:${var.aws_region}::parameter/aws/service/*"]

    sid = "AllowSSMReadActions"
  }

  statement {
    actions = [
      "pricing:GetProducts"
    ]

    effect    = "Allow"
    resources = ["*"]

    sid = "AllowPricingReadActions"
  }

  statement {
    actions = [
      "sqs:DeleteMessage",
      "sqs:GetQueueUrl",
      "sqs:ReceiveMessage"
    ]

    effect    = "Allow"
    resources = ["${aws_sqs_queue.node_interruption_queue.arn}"]

    sid = "AllowInterruptionQueueActions"
  }

  statement {
    actions = ["iam:PassRole"]

    effect    = "Allow"
    resources = ["${aws_iam_role.karpenter_node_role.arn}"]
    sid       = "AllowPassingInstanceRole"
    condition {
      test     = "StringEquals"
      variable = "iam:PassedToService"
      values = [
        "ec2.amazonaws.com"
      ]
    }
  }

  statement {
    sid       = "AllowScopedInstanceProfileCreationActions"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["iam:CreateInstanceProfile"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes.io/cluster/${module.eks.cluster_name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/topology.kubernetes.io/region"
      values   = ["${var.aws_region}"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass"
      values   = [local.e6data_nodeclass_name]
    }
  }

  statement {
    sid       = "AllowScopedInstanceProfileTagActions"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["iam:TagInstanceProfile"]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/kubernetes.io/cluster/${module.eks.cluster_name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/topology.kubernetes.io/region"
      values   = ["${var.aws_region}"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/kubernetes.io/cluster/${module.eks.cluster_name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/topology.kubernetes.io/region"
      values   = ["${var.aws_region}"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass"
      values   = [local.e6data_nodeclass_name]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/karpenter.k8s.aws/ec2nodeclass"
      values   = [local.e6data_nodeclass_name]
    }
  }

  statement {
    sid       = "AllowScopedInstanceProfileActions"
    effect    = "Allow"
    resources = ["*"]
    actions = [
      "iam:AddRoleToInstanceProfile",
      "iam:RemoveRoleFromInstanceProfile",
      "iam:DeleteInstanceProfile"
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/kubernetes.io/cluster/${module.eks.cluster_name}"
      values   = ["owned"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/topology.kubernetes.io/region"
      values   = ["${var.aws_region}"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/karpenter.k8s.aws/ec2nodeclass"
      values   = [local.e6data_nodeclass_name]
    }
  }

  statement {
    actions = ["eks:DescribeCluster"]

    effect    = "Allow"
    resources = ["arn:aws:eks:${var.aws_region}:${data.aws_caller_identity.current.account_id}:cluster/${module.eks.cluster_name}"]
    sid       = "EKSClusterEndpointLookup"
  }

  statement {
    sid       = "AllowInstanceProfileReadActions"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["iam:GetInstanceProfile"]
  }
}

resource "aws_iam_policy" "karpenter_controller_policy" {
  name        = "${module.eks.cluster_name}-karpenter-controller-${random_string.random.result}"
  description = "karpenter policy for cluster ${module.eks.cluster_name}"
  policy      = data.aws_iam_policy_document.karpenter_controller_policy_document.json
}

module "karpenter_oidc" {
  source = "./modules/aws_oidc"

  providers = {
    kubernetes = kubernetes.e6data
  }

  tls_url      = module.eks.eks_oidc_tls
  policy_arn   = [aws_iam_policy.karpenter_controller_policy.arn]
  eks_oidc_arn = module.eks.oidc_arn

  oidc_role_name = "${module.eks.cluster_name}-karpenter"

  kubernetes_namespace            = var.karpenter_namespace
  kubernetes_service_account_name = var.karpenter_service_account_name

  depends_on = [aws_iam_policy.karpenter_controller_policy, aws_eks_node_group.default_node_group]
}

module "karpeneter_deployment" {
  providers = {
    kubernetes = kubernetes.e6data
    helm       = helm.e6data
  }

  source = "./modules/karpenter"

  karpenter_release_version = var.karpenter_release_version

  namespace               = module.karpenter_oidc.kubernetes_namespace
  eks_cluster_name        = module.eks.cluster_name
  eks_endpoint            = module.eks.eks_endpoint
  service_account_name    = module.karpenter_oidc.service_account_name
  controller_role_arn     = module.karpenter_oidc.oidc_role_arn
  interruption_queue_name = aws_sqs_queue.node_interruption_queue.name

  depends_on = [module.eks, module.karpenter_oidc, aws_eks_node_group.default_node_group, aws_sqs_queue.node_interruption_queue]
}

data "aws_availability_zones" "available" {
  state         = "available"
  exclude_names = var.excluded_az
}

# Data source to fetch and template Karpenter provisioner manifests
data "kubectl_path_documents" "provisioner_manifests" {
  pattern = "./karpenter-provisioner-manifests/*.yaml"
  vars = {
    workspace_name           = var.workspace_name
    available_zones          = jsonencode(data.aws_availability_zones.available.names)
    cluster_name             = module.eks.cluster_name
    instance_family          = jsonencode(var.nodepool_instance_family)
    karpenter_node_role_name = aws_iam_role.karpenter_node_role.name
    volume_size              = var.eks_disk_size
    nodeclass_name           = local.e6data_nodeclass_name
    nodepool_name            = local.e6data_nodepool_name
    tags = jsonencode(
      merge(
        var.cost_tags,
        {
          "Name" = local.e6data_workspace_name
        }
      )
    )
    nodepool_cpu_limits = var.nodepool_cpu_limits
  }
  depends_on = [data.aws_availability_zones.available, aws_iam_role.karpenter_node_role, module.eks]
}

resource "kubectl_manifest" "provisioners" {
  count     = 2
  yaml_body = values(data.kubectl_path_documents.provisioner_manifests.manifests)[count.index]

  depends_on = [module.karpeneter_deployment]
}