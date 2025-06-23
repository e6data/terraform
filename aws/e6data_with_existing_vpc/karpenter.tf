# This resource adds a tag to each subnet in the network module
# to enable Karpenter to discover the EKS cluster.
resource "aws_ec2_tag" "karpenter_subnet_cluster_tag" {
  count       = length(module.network.private_subnet_ids)
  resource_id = module.network.private_subnet_ids[count.index]
  key         = "karpenter.sh/discovery"
  value       = module.eks.cluster_name
}

# Create an IAM policy for the Karpenter controller, granting necessary permissions for managing EKS nodes
resource "aws_iam_policy" "karpenter_controller_policy" {
  name        = "${module.eks.cluster_name}-karpenter-controller-${random_string.random.result}"
  description = "karpenter policy for cluster ${module.eks.cluster_name}"
  policy      = data.aws_iam_policy_document.karpenter_controller_policy_document.json
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

  # statement {
  #   actions = [
  #     "ec2:RunInstances",
  #     "ec2:CreateFleet"
  #   ]

  #   effect    = "Allow"
  #   resources = ["*"]
  #   sid       = "AllowScopedEC2LaunchTemplateAccessActions"
  #   condition {
  #     test     = "StringEquals"
  #     variable = "aws:ResourceTag/kubernetes.io/cluster/${module.eks.cluster_name}"
  #     values   = ["owned"]
  #   }
  # }

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
    # condition {
    #   test     = "StringEquals"
    #   variable = "aws:RequestTag/kubernetes.io/cluster/${module.eks.cluster_name}"
    #   values   = ["owned"]
    # }
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
    # condition {
    #   test     = "StringEquals"
    #   variable = "aws:RequestTag/kubernetes.io/cluster/${module.eks.cluster_name}"
    #   values   = ["owned"]
    # }
    condition {
      test     = "StringEquals"
      variable = "ec2:CreateAction"
      values = [
        "RunInstances",
        "CreateFleet",
        "CreateLaunchTemplate"
      ]
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
}

# Grants Karpenter controller scoped permissions to manage EC2 resources, including creation, tagging, and deletion, with conditions to limit actions to specific cluster and nodepool tags.
data "aws_iam_policy_document" "karpenter_controller_policy_document_v2" {
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
    resources = [aws_sqs_queue.node_interruption_queue.arn]

    sid = "AllowInterruptionQueueActions"
  }

  statement {
    actions = ["iam:PassRole"]

    effect    = "Allow"
    resources = "*"
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

    # condition {
    #   test     = "StringEquals"
    #   variable = "aws:RequestTag/kubernetes.io/cluster/${module.eks.cluster_name}"
    #   values   = ["owned"]
    # }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/topology.kubernetes.io/region"
      values   = ["${var.aws_region}"]
    }
  }

  statement {
    sid       = "AllowScopedInstanceProfileTagActions"
    effect    = "Allow"
    resources = ["*"]
    actions   = ["iam:TagInstanceProfile"]

    # condition {
    #   test     = "StringEquals"
    #   variable = "aws:ResourceTag/kubernetes.io/cluster/${module.eks.cluster_name}"
    #   values   = ["owned"]
    # }

    condition {
      test     = "StringEquals"
      variable = "aws:ResourceTag/topology.kubernetes.io/region"
      values   = ["${var.aws_region}"]
    }

    # condition {
    #   test     = "StringEquals"
    #   variable = "aws:RequestTag/kubernetes.io/cluster/${module.eks.cluster_name}"
    #   values   = ["owned"]
    # }

    condition {
      test     = "StringEquals"
      variable = "aws:RequestTag/topology.kubernetes.io/region"
      values   = ["${var.aws_region}"]
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
  name        = "${module.eks.cluster_name}-karpenter-controller-policy"
  description = "karpenter policy for cluster ${module.eks.cluster_name}"
  policy      = data.aws_iam_policy_document.karpenter_controller_policy_document.json
}

resource "aws_iam_policy" "karpenter_controller_policy_v2" {
  name        = "${module.eks.cluster_name}-karpenter-controller-policy-v2"
  description = "karpenter policy v2 for cluster ${module.eks.cluster_name}"
  policy      = data.aws_iam_policy_document.karpenter_controller_policy_document_v2.json
}

# Configure the OIDC provider for Karpenter to enable integration with EKS
module "karpenter_oidc" {
  source = "./modules/aws_oidc"

  providers = {
    kubernetes = kubernetes.e6data
  }

  tls_url      = module.eks.eks_oidc_tls
  policy_arn   = [aws_iam_policy.karpenter_controller_policy.arn, aws_iam_policy.karpenter_controller_policy_v2.arn]
  eks_oidc_arn = module.eks.oidc_arn

  oidc_role_name = "${module.eks.cluster_name}-karpenter"

  kubernetes_namespace            = var.karpenter_namespace
  kubernetes_service_account_name = var.karpenter_service_account_name

  depends_on = [aws_iam_policy.karpenter_controller_policy, aws_eks_node_group.default_node_group, module.e6data_authentication]
}

# Deploy Karpenter in the specified Kubernetes namespace to manage EKS node provisioning
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

  karpenter_controller_image_repository = var.karpenter_controller_image_repository
  karpenter_controller_image_tag        = var.karpenter_controller_image_tag

  depends_on = [module.eks, module.karpenter_oidc, aws_eks_node_group.default_node_group, aws_sqs_queue.node_interruption_queue, module.e6data_authentication]
}

# Data source to fetch and template Karpenter provisioner manifests
data "kubectl_path_documents" "provisioner_manifests" {
  pattern = "./karpenter-provisioner-manifests/*.yaml"
  vars = {
    workspace_name           = var.workspace_name
    available_zones          = jsonencode(module.network.private_subnet_azs)
    cluster_name             = module.eks.cluster_name
    instance_family          = jsonencode(var.nodepool_instance_family)
    karpenter_node_role_name = aws_iam_role.eks_nodegroup_iam_role.name
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
  depends_on = [ aws_iam_role.eks_nodegroup_iam_role, module.eks]
}

resource "kubectl_manifest" "provisioners" {
  count     = 2
  yaml_body = values(data.kubectl_path_documents.provisioner_manifests.manifests)[count.index]

  depends_on = [module.karpeneter_deployment, module.e6data_authentication]
}