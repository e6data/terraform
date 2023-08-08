resource "aws_ec2_tag" "subnet_cluster_tag" {
  count    =    length(var.subnet_ids)
  resource_id = var.subnet_ids[count.index]
  key         = "kubernetes.io/cluster/${var.cluster_name}"
  value       = "shared"
}
