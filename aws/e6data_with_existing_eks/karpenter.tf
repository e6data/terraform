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
    cluster_name             = var.eks_cluster_name
    instance_family          = jsonencode(var.nodepool_instance_family)
    karpenter_node_role_name = basename(data.aws_eks_node_group.current.node_role_arn)
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
  depends_on = [data.aws_availability_zones.available]
}

resource "kubectl_manifest" "provisioners" {
  count     = 2
  yaml_body = values(data.kubectl_path_documents.provisioner_manifests.manifests)[count.index]

  depends_on = [data.kubectl_path_documents.provisioner_manifests]
}