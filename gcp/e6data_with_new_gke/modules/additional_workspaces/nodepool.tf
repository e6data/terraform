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
    machine_type = var.workspaces[count.index].nodepool_instance_type
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

# # # Create GCS bucket for workspace
resource "google_storage_bucket" "workspace_bucket" {
  count    = length(var.workspaces)
  name     = "${var.workspaces[count.index].name}-${random_string.random[count.index].result}"
  location = var.gcp_region
}

# # # Create service account for workspace
resource "google_service_account" "workspace_sa" {
  for_each = {
    for idx, workspace in var.workspaces : idx => workspace
    if workspace.serviceaccount_create
  }

  account_id   = "${each.value.name}-${var.random_string}"
  display_name = "${each.value.name}-${var.random_string}"
  description  = "Service account for e6data workspace access"
}


# # Assign the custom role to either all buckets or specific buckets based on the value of the 'buckets' variable
resource "google_project_iam_member" "workspace_read_project_binding" {
  for_each = local.workspaces_with_star_buckets

  project = var.gcp_project_id
  role    = var.buckets_read_role_name

  member  = each.value.serviceaccount_create ? "serviceAccount:${google_service_account.workspace_sa[each.key].email}" : "serviceAccount:${each.value.serviceaccount_email}"

  depends_on = [
    google_service_account.workspace_sa
  ]
}

resource "google_storage_bucket_iam_member" "workspace_read_bucket_binding" {
  for_each = {
    for item in local.workspace_bucket_bindings :
    "${item.idx}-${item.bucket}" => item
  }

  bucket = each.value.bucket
  role   = var.buckets_read_role_name

  member = each.value.workspace.serviceaccount_create ? "serviceAccount:${google_service_account.workspace_sa[regex("\\d+", each.key)].email}" : "serviceAccount:${each.value.workspace.serviceaccount_email}"
}

# # # Create IAM policy binding for workspace service account and GCS bucket write access
resource "google_storage_bucket_iam_binding" "workspace_write_binding" {
  for_each = {
    for idx, workspace in var.workspaces : idx => workspace
  }

  bucket = google_storage_bucket.workspace_bucket[each.key].name
  role   = var.buckets_write_role_name
  
  members = [
    "serviceAccount:${local.member_emails[each.key]}",
    "serviceAccount:${var.platform_sa_email}"
  ]

  depends_on = [
    google_storage_bucket.workspace_bucket,
    google_service_account.workspace_sa
  ]
}

# # Create IAM policy binding for workspace service account and Kubernetes cluster
resource "google_project_iam_member" "workspace_ksa_mapping" {
  count   = length(var.workspaces)
  project = var.gcp_project_id
  role    = var.workloadIdentityUser_role_name
  member =  "serviceAccount:${var.gcp_project_id}.svc.id.goog[${var.workspaces[count.index].namespace}/${var.workspaces[count.index].name}]"
}
