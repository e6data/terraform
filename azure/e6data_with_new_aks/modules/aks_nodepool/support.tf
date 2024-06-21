locals {
  node_labels = merge(
    {
      "app" = "e6data"
      "e6data-workspace-name" = var.nodepool_name
    },
    var.priority == "Spot" ? {
      "kubernetes.azure.com/scalesetpriority" = "spot"
    } : {}
  )

  node_taints = concat(
    ["e6data-workspace-name=${var.nodepool_name}:NoSchedule"],
    var.priority == "Spot" ? ["kubernetes.azure.com/scalesetpriority=spot:NoSchedule"] : []
  )
}