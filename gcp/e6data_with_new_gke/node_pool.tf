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
    spot         = local.workspaces[count.index].spot_enabled
    machine_type = local.workspaces[count.index].nodepool_instance_type
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

# # Create GCS bucket for workspace
resource "google_storage_bucket" "workspace_bucket" {
  count    = length(local.workspaces)
  name     = "${local.workspaces[count.index].e6data_workspace_name}-${random_string.random[count.index].result}"
  location = var.gcp_region
}

# # Create service account for workspace
resource "google_service_account" "workspace_sa" {
  account_id   = "${local.workspaces[0].e6data_workspace_name}-${random_string.random.0.result}"
  display_name = "${local.workspaces[0].e6data_workspace_name}-${random_string.random.0.result}"
  description  = "Service account for e6data workspace access"
}

# # Create IAM role for workspace write access on GCS bucket
resource "google_project_iam_custom_role" "workspace_write_role" {
  role_id     = "${local.workspace_write_role_name}_${random_string.random.0.result}"
  title       = "e6data ${var.workspace_names[0].name} Workspace Write Access ${random_string.random.0.result}"
  description = "Custom e6data workspace role for GCS write access "

  permissions = [
    "storage.objects.getIamPolicy",
    "storage.objects.update",
    "storage.objects.create",
    "storage.objects.delete",
    "storage.objects.get",
    "storage.objects.list"
  ]
}

# # Create IAM role for workspace read access on GCS buckets
resource "google_project_iam_custom_role" "workspace_read_role" {
  role_id     = "${local.workspace_read_role_name}_${random_string.random.0.result}"
  title       = "e6data ${var.workspace_names[0].name} Workspace Read Access ${random_string.random.0.result}"
  description = "Custom e6data workspace role for GCS read access"

  permissions = [
    "storage.objects.getIamPolicy",
    "storage.objects.get",
    "storage.objects.list",
  ]
}

# Assign the custom role to either all buckets or specific buckets based on the value of the 'buckets' variable
resource "google_project_iam_binding" "workspace_read_project_binding" {
  count   = contains(var.buckets, "*") ? 1 : 0
  project = var.gcp_project_id
  role    = google_project_iam_custom_role.workspace_read_role.name

  members = [
    "serviceAccount:${google_service_account.workspace_sa.email}",
  ]

  depends_on = [google_project_iam_custom_role.workspace_read_role, google_storage_bucket.workspace_bucket, google_service_account.workspace_sa]
}

resource "google_storage_bucket_iam_member" "workspace_read_bucket_binding" {
  count  = contains(var.buckets, "*") ? 0 : length(var.buckets)
  bucket = var.buckets[count.index]
  role   = google_project_iam_custom_role.workspace_read_role.name
  member = "serviceAccount:${google_service_account.workspace_sa.email}"
}

## IAM binding to the customer serviceaaccount to access workspace gcs bucket
resource "google_storage_bucket_iam_binding" "workspace_write_binding" {
  count  = length(var.workspace_names)
  bucket = google_storage_bucket.workspace_bucket[count.index].name
  role   = google_project_iam_custom_role.workspace_write_role.name
  members = [
    "serviceAccount:${google_service_account.workspace_sa.email}",
    "serviceAccount:${var.platform_sa_email}"
  ]

  depends_on = [google_project_iam_custom_role.workspace_write_role, google_storage_bucket.workspace_bucket, google_service_account.workspace_sa]
}

resource "google_project_iam_custom_role" "e6dataclusterViewer" {
  role_id     = "${local.cluster_viewer_role_name}_${random_string.random.0.result}"
  title       = "e6data ${var.workspace_names[0].name} clusterViewer ${random_string.random.0.result}"
  description = "kubernetes container clusterViewer access"
  permissions = [
    "container.clusters.get",
    "container.clusters.list",
    "container.roleBindings.get",
    "container.backendConfigs.get",
    "container.backendConfigs.create",
    "container.backendConfigs.delete",
    "container.backendConfigs.update",
    "resourcemanager.projects.get",
    "compute.projects.get",
    "compute.sslCertificates.get",
    "compute.forwardingRules.list",
    "compute.regionBackendServices.get"
  ]
  stage   = "GA"
  project = var.gcp_project_id
}

# Create IAM policy binding for Platform Service and Kubernetes cluster
resource "google_project_iam_binding" "platform_ksa_mapping" {
  project = var.gcp_project_id
  role    = google_project_iam_custom_role.e6dataclusterViewer.name
  members = [
    "serviceAccount:${var.platform_sa_email}",
  ]
}

resource "google_project_iam_custom_role" "GlobalAddress" {
  role_id     = "${local.cluster_viewer_role_name}_${random_string.random.0.result}_global_address_create"
  title       = "e6data ${var.workspace_names[0].name} GlobalAddress ${random_string.random.0.result}"
  description = "Global address create access"
  permissions = [
    "compute.globalAddresses.create",
    "compute.globalAddresses.delete",
    "compute.globalAddresses.get",
    "compute.globalAddresses.setLabels"
  ]
  stage   = "GA"
  project = var.gcp_project_id
}

resource "google_project_iam_custom_role" "security_policy" {
  role_id     = "${local.cluster_viewer_role_name}_${random_string.random.0.result}_security_policy"
  title       = "e6data ${var.workspace_names[0].name} security policy ${random_string.random.0.result}"
  description = "Global address access"
  permissions = [
    "compute.securityPolicies.create",
    "compute.securityPolicies.get",
    "compute.securityPolicies.delete",
    "compute.securityPolicies.update"
  ]
  stage   = "GA"
  project = var.gcp_project_id
}

# Create IAM policy binding for Platform Service and Kubernetes cluster
resource "google_project_iam_binding" "global_address_create_mapping" {
  project = var.gcp_project_id
  role    = google_project_iam_custom_role.GlobalAddress.name
  members = [
    "serviceAccount:${var.platform_sa_email}",
  ]
  condition {
    title       = "Global Address write Access"
    description = "Global Address write Access"
    expression  = "resource.name.startsWith(\"projects/${var.gcp_project_id}/global/addresses/e6data\")"
  }
}

resource "google_project_iam_binding" "security_policy_create_mapping" {
  project = var.gcp_project_id
  role    = google_project_iam_custom_role.security_policy.name
  members = [
    "serviceAccount:${var.platform_sa_email}",
  ]
  condition {
    title       = "security_policy write Access"
    description = "security_policy write Access"
    expression  = "resource.name.startsWith(\"projects/${var.gcp_project_id}/global/securityPolicies/e6data\")"
  }
}

resource "google_project_iam_custom_role" "workloadIdentityUser" {
  role_id     = "${local.workload_role_name}_${random_string.random.0.result}"
  title       = "e6data ${var.workspace_names[0].name} workloadIdentityUser Access ${random_string.random.0.result}"
  description = "e6data custom workload identity user role"
  permissions = [
    "iam.serviceAccounts.get",
    "iam.serviceAccounts.list",
    "iam.serviceAccounts.getAccessToken",
    "iam.serviceAccounts.getOpenIdToken"
  ]
  stage   = "GA"
  project = var.gcp_project_id
}

# Create IAM policy binding for workspace service account and Kubernetes cluster
resource "google_project_iam_member" "workspace_ksa_mapping" {
  count   = length(var.workspace_names)
  project = var.gcp_project_id
  role    = google_project_iam_custom_role.workloadIdentityUser.name
  member =  "serviceAccount:${var.gcp_project_id}.svc.id.goog[${var.workspace_names[count.index].namespace}/${var.workspace_names[count.index].name}]"
}

resource "google_project_iam_custom_role" "targetpoolAccess" {
  role_id     = "${local.target_pool_role_name}_${random_string.random.0.result}"
  title       = "e6data ${var.workspace_names[0].name} targetpoolAccess ${random_string.random.0.result}"
  description = "gcp targetpool access"
  permissions = [
    "compute.instances.get",
    "compute.targetPools.get",
    "compute.targetPools.list"
  ]
  stage   = "GA"
  project = var.gcp_project_id
}

# Create IAM policy binding for targetpool access and Kubernetes cluster
resource "google_project_iam_binding" "targetpool_ksa_mapping" {
  project = var.gcp_project_id
  role    = google_project_iam_custom_role.targetpoolAccess.name
  members = [
    "serviceAccount:${var.platform_sa_email}",
  ]
}