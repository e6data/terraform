# # Create GKE nodepool for workspace
resource "google_container_node_pool" "workspace" {
  count = length(local.workspaces)

  name_prefix        = local.workspaces[count.index].e6data_workspace_name
  cluster            = module.gke_e6data.gke_cluster_id
  initial_node_count = 0

  autoscaling {
    total_min_node_count = 0
    total_max_node_count = local.workspaces[count.index].max_instances_in_nodepool
    location_policy      = "ANY"
  }

  node_config {
    disk_size_gb = 100
    spot         = true
    machine_type = local.workspaces[count.index].spot_nodepool_instance_type
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
    resource_labels = local.workspaces[count.index].cost_labels

    labels = {
      e6data-workspace-name = local.workspaces[count.index].name
      app                   = "e6data"
    }

    taint {
      key    = "e6data-workspace-name"
      value  = local.workspaces[count.index].name
      effect = "NO_SCHEDULE"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# # # Create GKE nodepool for workspace
resource "google_container_node_pool" "workspace_ondemand" {
  count = length(local.workspaces)

  name_prefix        = local.workspaces[count.index].name
  cluster            = module.gke_e6data.gke_cluster_id
  initial_node_count = 0

  autoscaling {
    total_min_node_count = 0
    total_max_node_count = local.workspaces[count.index].max_instances_in_nodepool
    location_policy      = "ANY"
  }

  node_config {
    disk_size_gb = 100
    spot         = false
    machine_type = local.workspaces[count.index].ondemand_nodepool_instance_type
    workload_metadata_config {
      mode = "GKE_METADATA"
    }
    resource_labels = local.workspaces[count.index].cost_labels

    labels = {
      e6data-workspace-name = "${local.workspaces[count.index].name}-executor"
      app                   = "e6data"
    }

    taint {
      key    = "e6data-workspace-name"
      value  = local.workspaces[count.index].name
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