# Create EKS node group for workspace
resource "aws_launch_template" "default_nodegroup_launch_template" {
  # name = "${local.e6data_workspace_name}-default-nodegroup-launch-template-${element(split(".", var.kube_version),1)}"
  name_prefix = "${local.e6data_workspace_name}-default-ng-"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 20
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      { Name = "${local.e6data_workspace_name}-default" },
      var.cost_tags
    )
  }

  tag_specifications {
    resource_type = "volume"

    tags = merge(
      { Name = "${local.e6data_workspace_name}-default" },
      var.cost_tags
    )
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 2
    instance_metadata_tags      = "enabled"
  }

  lifecycle {
    create_before_destroy = true
  }
}

# Create a default EKS node group in the specified cluster with defined instance types and scaling configuration
resource "aws_eks_node_group" "default_node_group" {
  cluster_name = module.eks.cluster_name
  version      = var.default_nodegroup_kube_version
  # node_group_name = "${local.e6data_workspace_name}-default-${element(split(".", var.kube_version),1)}"
  node_group_name_prefix = "${local.e6data_workspace_name}-default-ng-"
  node_role_arn          = aws_iam_role.eks_nodegroup_iam_role.arn
  ami_type               = "AL2_ARM_64"
  subnet_ids             = module.network.private_subnet_ids
  capacity_type          = var.eks_capacity_type
  force_update_version   = true
  instance_types         = ["t4g.medium"]
  launch_template {
    id      = aws_launch_template.default_nodegroup_launch_template.id
    version = aws_launch_template.default_nodegroup_launch_template.latest_version
  }

  scaling_config {
    min_size     = 2
    desired_size = 2
    max_size     = 3
  }

  update_config {
    max_unavailable = 2
  }

  labels = {
    "app"                   = "e6data"
    "e6data-workspace-name" = "default"
  }

  tags = merge({
    "Name" = "${local.e6data_workspace_name}-default"
  }, var.cost_tags)

  lifecycle {
    ignore_changes        = [scaling_config[0].desired_size, scaling_config[0].min_size, update_config, tags]
    create_before_destroy = true
  }

  depends_on = [aws_iam_role.eks_nodegroup_iam_role, module.eks]
}

data "aws_iam_policy_document" "eks_nodegroup_iam_assume_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "eks_nodegroup_iam_role" {
  name                = "${local.e6data_workspace_name}-${random_string.random.result}"
  managed_policy_arns = var.eks_nodegroup_iam_policy_arn
  assume_role_policy  = data.aws_iam_policy_document.eks_nodegroup_iam_assume_policy.json
}
