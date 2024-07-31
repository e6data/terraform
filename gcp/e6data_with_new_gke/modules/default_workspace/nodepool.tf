terraform {
  required_providers {
    helm = {
      source = "hashicorp/helm"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

# # Create GKE nodepool for workspace
resource "google_container_node_pool" "workspace" {
  name_prefix = var.e6data_workspace_name
  location    = var.gcp_region
  cluster     = var.gke_cluster_id

  initial_node_count = 0
  autoscaling {
    total_min_node_count = 0
    total_max_node_count = var.total_max_node_count
    location_policy      = "ANY"
  }
  node_config {
    disk_size_gb = 100
    spot         = var.spot_enabled
    machine_type = var.machine_type
    workload_metadata_config {
      mode = "GKE_METADATA"
    }

    labels = {
      e6data-workspace-name = var.workspace_name
      app                   = "e6data"
    }

    taint {
      key    = "e6data-workspace-name"
      value  = var.workspace_name
      effect = "NO_SCHEDULE"
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# # Create GCS bucket for workspace
resource "google_storage_bucket" "workspace_bucket" {
  name     = "${var.e6data_workspace_name}-${var.random_string}"
  location = var.gcp_region
}

# # Create service account for workspace
resource "google_service_account" "workspace_sa" {
  account_id   = "${var.e6data_workspace_name}-${var.random_string}"
  display_name = "${var.e6data_workspace_name}-${var.random_string}"
  description  = "Service account for e6data workspace access"
}

# # Create IAM role for workspace write access on GCS bucket
resource "google_project_iam_custom_role" "workspace_write_role" {
  role_id     = "${var.workspace_write_role_name}_${var.random_string}"
  title       = "e6data ${var.workspace_name} Workspace Write Access ${var.random_string}"
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
  role_id     = "${var.workspace_read_role_name}_${var.random_string}"
  title       = "e6data ${var.workspace_name} Workspace Read Access ${var.random_string}"
  description = "Custom e6data workspace role for GCS read access"

  permissions = [
    "storage.objects.getIamPolicy",
    "storage.objects.get",
    "storage.objects.list",
  ]
}

# Assign the custom role to either all buckets or specific buckets based on the value of the 'buckets' variable
resource "google_project_iam_member" "workspace_read_project_binding" {
  count   = contains(var.buckets, "*") ? 1 : 0
  project = var.gcp_project_id
  role    = google_project_iam_custom_role.workspace_read_role.name

  member = "serviceAccount:${google_service_account.workspace_sa.email}"

  depends_on = [google_project_iam_custom_role.workspace_read_role, google_storage_bucket.workspace_bucket, google_service_account.workspace_sa]
}

resource "google_storage_bucket_iam_member" "workspace_read_bucket_binding" {
  count  = contains(var.buckets, "*") ? 0 : length(var.buckets)
  bucket = var.buckets[count.index]
  role   = google_project_iam_custom_role.workspace_read_role.name
  member = "serviceAccount:${google_service_account.workspace_sa.email}"
}

# # Create IAM policy binding for workspace service account and GCS bucket write access
resource "google_project_iam_binding" "workspace_write_binding" {
  project = var.gcp_project_id
  role    = google_project_iam_custom_role.workspace_write_role.name

  members = [
    "serviceAccount:${google_service_account.workspace_sa.email}",
  ]

  condition {
    title       = "Workspace Write Access"
    description = "Write access to e6data workspace GCS bucket"
    expression  = "resource.name.startsWith(\"projects/_/buckets/${var.e6data_workspace_name}-${var.random_string}/\")"
  }

  depends_on = [google_project_iam_custom_role.workspace_write_role, google_storage_bucket.workspace_bucket, google_service_account.workspace_sa]
}

resource "google_project_iam_binding" "platform_gcs_read_binding" {
  project = var.gcp_project_id
  role    = google_project_iam_custom_role.workspace_write_role.name

  members = [
    "serviceAccount:${var.platform_sa_email}",
  ]

  condition {
    title       = "Workspace Read Access"
    description = "Read access to e6data workspace GCS bucket"
    expression  = "resource.name.startsWith(\"projects/_/buckets/${var.e6data_workspace_name}-${var.random_string}/\")"
  }

  depends_on = [google_project_iam_custom_role.workspace_write_role, google_storage_bucket.workspace_bucket]
}

resource "google_project_iam_custom_role" "e6dataclusterViewer" {
  role_id     = "${var.cluster_viewer_role_name}_${var.random_string}"
  title       = "e6data ${var.workspace_name} clusterViewer ${var.random_string}"
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
  role_id     = "${var.cluster_viewer_role_name}_${var.random_string}_global_address_create"
  title       = "e6data ${var.workspace_name} GlobalAddress ${var.random_string}"
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
  role_id     = "${var.cluster_viewer_role_name}_${var.random_string}_security_policy"
  title       = "e6data ${var.workspace_name} security policy ${var.random_string}"
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
  role_id     = "${var.workload_role_name}_${var.random_string}"
  title       = "e6data ${var.workspace_name} workloadIdentityUser Access ${var.random_string}"
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
  project = var.gcp_project_id
  role    = google_project_iam_custom_role.workloadIdentityUser.name
  member  = "serviceAccount:${var.gcp_project_id}.svc.id.goog[${var.kubernetes_namespace}/${var.workspace_name}]"
}

resource "google_project_iam_custom_role" "targetpoolAccess" {
  role_id     = "${var.target_pool_role_name}_${var.random_string}"
  title       = "e6data ${var.workspace_name} targetpoolAccess ${var.random_string}"
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