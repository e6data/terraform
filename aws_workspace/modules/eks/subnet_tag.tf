resource "aws_ec2_tag" "subnet_cluster_tag" {
  count    =    length(var.subnet_ids)
  resource_id = var.subnet_ids[count.index]
  key         = "kubernetes.io/cluster/e6data-${var.cluster_name}"
  value       = "shared"

  depends_on = [ aws_eks_cluster.eks ]
}
