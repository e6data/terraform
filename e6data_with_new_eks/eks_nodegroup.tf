# Create EKS node group for workspace
resource "aws_launch_template" "nodegroup_launch_template" {
  name = "${local.e6data_workspace_name}-nodegroup-launch-template-${element(split(".", var.kube_version),1)}"

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.eks_disk_size
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(
      { 
        Name = local.e6data_workspace_name
        "k8s.io/cluster-autoscaler/node-template/taint/e6data-workspace-name" = "${var.workspace_name}:true:NoSchedule"
      },
      var.cost_tags
    )  
  }

  tag_specifications {
    resource_type = "volume"

    tags = merge(
      { 
        Name = local.e6data_workspace_name
      },
      var.cost_tags
    )  
  }

  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "disabled"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eks_node_group" "workspace_node_group" {
  cluster_name    = module.eks.cluster_name
  version         = var.kube_version
  node_group_name = "${local.e6data_workspace_name}-${element(split(".", var.kube_version),1)}"
  node_role_arn   = aws_iam_role.eks_nodegroup_iam_role.arn
  ami_type        = "AL2_ARM_64"
  subnet_ids      = [element(module.network.private_subnet_ids, 0)]
  capacity_type   = var.eks_capacity_type
  force_update_version = true
  instance_types = var.eks_nodegroup_instance_types
  launch_template {
    id      = aws_launch_template.nodegroup_launch_template.id
    version = aws_launch_template.nodegroup_launch_template.latest_version
  }

  scaling_config {
    min_size     = var.min_instances_in_eks_nodegroup
    desired_size = var.desired_instances_in_eks_nodegroup
    max_size     = var.max_instances_in_eks_nodegroup
  }

  update_config {
    max_unavailable = 2
  }

  labels = {
    "app" = "e6data"
    "e6data-workspace-name" = var.workspace_name
  }

  taint {
    key    = "e6data-workspace-name"
    value  = var.workspace_name
    effect = "NO_SCHEDULE"
  }

  tags = merge({
    "Name" = local.e6data_workspace_name
    "k8s.io/cluster-autoscaler/enabled" =  "true"
    "k8s.io/cluster-autoscaler/${module.eks.cluster_name}" = "owned"
  }, var.cost_tags )

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size, scaling_config[0].min_size,  update_config , tags]
    create_before_destroy = true
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

resource "null_resource" "nodegroup_asg_update" {

  provisioner "local-exec" {
    interpreter = ["/bin/sh", "-c"]
    command = <<EOF
set -e

${var.aws_command_line_path} autoscaling update-auto-scaling-group \
  --auto-scaling-group-name ${aws_eks_node_group.workspace_node_group.resources[0].autoscaling_groups[0].name} \
  --no-capacity-rebalance
EOF
  }

  depends_on = [aws_eks_node_group.workspace_node_group]
}

resource "aws_autoscaling_group_tag" "autoscaler_tag" {

  autoscaling_group_name = aws_eks_node_group.workspace_node_group.resources[0].autoscaling_groups[0].name
  
  tag {
    key                 = "k8s.io/cluster-autoscaler/node-template/taint/e6data-workspace-name"
    value               = "${var.workspace_name}:true:NoSchedule"
    propagate_at_launch = true
  }
}