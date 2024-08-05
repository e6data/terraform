# # # Create GKE nodepool for workspace
resource "google_container_node_pool" "workspace" {
  count = length(var.workspaces)

  name_prefix        = var.workspaces[count.index].name
  cluster            = var.gke_cluster_id
  initial_node_count = 0

  autoscaling {
    total_min_node_count = 0
    total_max_node_count = var.workspaces[count.index].max_instances_in_nodepool
    location_policy      = "ANY"
  }

  node_config {
    disk_size_gb = 100
    spot         = var.workspaces[count.index].spot_enabled
    machine_type = var.workspaces[count.index].spot_nodepool_instance_type
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
    resource_labels = var.workspaces[count.index].cost_labels

    labels = {
      e6data-workspace-name = var.workspaces[count.index].name
      app                   = "e6data"
    }

    taint {
      key    = "e6data-workspace-name"
      value  = var.workspaces[count.index].name
      effect = "NO_SCHEDULE"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# # # Create GKE nodepool for workspace
resource "google_container_node_pool" "workspace_ondemand" {
  count = length(var.workspaces)

  name_prefix        = var.workspaces[count.index].name
  cluster            = var.gke_cluster_id
  initial_node_count = 0

  autoscaling {
    total_min_node_count = 0
    total_max_node_count = var.workspaces[count.index].max_instances_in_nodepool
    location_policy      = "ANY"
  }

  node_config {
    disk_size_gb = 100
    spot         = false
    machine_type = var.workspaces[count.index].ondemand_nodepool_instance_type
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
    resource_labels = var.workspaces[count.index].cost_labels

    labels = {
      e6data-workspace-name = "${var.workspaces[count.index].name}-executor"
      app                   = "e6data"
    }

    taint {
      key    = "e6data-workspace-name"
      value  = var.workspaces[count.index].name
      effect = "NO_SCHEDULE"
    }
    taint {
      key    = "e6data-capacity-type"
      value  = "on-demand"
      effect = "NO_SCHEDULE"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}