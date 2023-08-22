# Create EKS node group for workspace
resource "aws_launch_template" "nodegroup_launch_template" {
  name = "${local.e6data_workspace_name}-nodegroup-launch-template"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.eks_disk_size
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      { Name = local.e6data_workspace_name},
      var.cost_tags
    )  
  }

  tag_specifications {
    resource_type = "volume"

    tags = merge(
      { Name = local.e6data_workspace_name},
      var.cost_tags
    )  
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eks_node_group" "workspace_node_group" {
  cluster_name    = module.eks.cluster_name
  version         = var.kube_version
  node_group_name = local.e6data_workspace_name
  node_role_arn   = aws_iam_role.eks_nodegroup_iam_role.arn
  ami_type        = "AL2_ARM_64"
  subnet_ids      = module.network.private_subnet_ids
  capacity_type   = var.eks_capacity_type
  force_update_version = true
  instance_types = var.eks_nodegroup_instance_types
  launch_template {
    id      = aws_launch_template.nodegroup_launch_template.id
    version = aws_launch_template.nodegroup_launch_template.latest_version
  }

  scaling_config {
    min_size     = var.min_desired_instances_in_eks_nodegroup
    desired_size = var.min_desired_instances_in_eks_nodegroup
    max_size     = var.max_instances_in_eks_nodegroup
  }

  update_config {
    max_unavailable = 2
  }

  tags = {
    "Name" = local.e6data_workspace_name
    "k8s.io/cluster-autoscaler/enabled" =  "true"
    "k8s.io/cluster-autoscaler/${module.eks.cluster_name}" = "owned"
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size, scaling_config[0].min_size, labels, update_config ]
  }

  depends_on = [ aws_iam_role.eks_nodegroup_iam_role ,module.eks]
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
  name = local.e6data_workspace_name
  managed_policy_arns = var.eks_nodegroup_iam_policy_arn
  assume_role_policy = data.aws_iam_policy_document.eks_nodegroup_iam_assume_policy.json
}