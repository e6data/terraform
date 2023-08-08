resource "aws_eks_node_group" "eks_worker_node" {
  cluster_name    = var.cluster_name
  node_group_name = "${var.cluster_name}-default-node-group"
  version         = var.kube_version
  node_role_arn   = aws_iam_role.iam_eks_node_role.arn
  subnet_ids      = var.private_subnet_ids
  instance_types = var.instance_type
  capacity_type  = var.capacity_type
  force_update_version = true
  disk_size = var.disk_size

  scaling_config {
    min_size     = var.min_size
    desired_size = var.desired_size
    max_size     = var.max_size
  }

  update_config {
    max_unavailable = 2
  }

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size, labels, update_config ]
  }

  tags = {
    "Name" = "${var.cluster_name}-default-asg"
    "k8s.io/cluster-autoscaler/enabled" = "true"
    "k8s.io/cluster-autoscaler/${var.cluster_name}" = "owned"
  }

  depends_on = [aws_eks_cluster.eks]
}
