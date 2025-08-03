# # Create GKE nodepool for workspace
resource "google_container_node_pool" "workspace" {
  name_prefix = local.e6data_workspace_name
  location    = var.gcp_region
  cluster     = module.gke_e6data.gke_cluster_id
  version     = var.gke_version

  initial_node_count = 0
  autoscaling {
    total_min_node_count = 0
    total_max_node_count = var.max_instances_in_nodepool
    location_policy      = "ANY"
  }
  node_config {
    disk_size_gb = 100
    spot         = var.spot_enabled
    machine_type = var.gke_e6data_instance_type
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
  name     = "${local.e6data_workspace_name}-${random_string.random.result}"
  location = var.gcp_region
}

# # Create service account for workspace
resource "google_service_account" "workspace_sa" {
  account_id   = "${local.e6data_workspace_name}-${random_string.random.result}"
  display_name = "${local.e6data_workspace_name}-${random_string.random.result}"
  description  = "Service account for e6data workspace access"
}

# # Create IAM role for workspace write access on GCS bucket
resource "google_project_iam_custom_role" "workspace_write_role" {
  role_id     = "${local.workspace_write_role_name}_${random_string.random.result}"
  title       = "e6data ${var.workspace_name} Workspace Write Access ${random_string.random.result}"
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
  role_id     = "${local.workspace_read_role_name}_${random_string.random.result}"
  title       = "e6data ${var.workspace_name} Workspace Read Access ${random_string.random.result}"
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
    expression  = "resource.name.startsWith(\"projects/_/buckets/${local.e6data_workspace_name}-${random_string.random.result}/\")"
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
    expression  = "resource.name.startsWith(\"projects/_/buckets/${local.e6data_workspace_name}-${random_string.random.result}/\")"
  }

  depends_on = [google_project_iam_custom_role.workspace_write_role, google_storage_bucket.workspace_bucket]
}

resource "google_project_iam_custom_role" "e6dataclusterViewer" {
  role_id     = "${local.cluster_viewer_role_name}_${random_string.random.result}"
  title       = "e6data ${var.workspace_name} clusterViewer ${random_string.random.result}"
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
  role_id     = "${local.cluster_viewer_role_name}_${random_string.random.result}_global_address_create"
  title       = "e6data ${var.workspace_name} GlobalAddress ${random_string.random.result}"
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

resource "google_project_iam_custom_role" "RegionalAddress" {
  role_id     = "${local.cluster_viewer_role_name}_${random_string.random.result}_regional_address_create"
  title       = "e6data ${var.workspace_name} RegionalAddress ${random_string.random.result}"
  description = "Regional address create access including internal operations"
  permissions = [
    "compute.addresses.create",
    "compute.addresses.createInternal",
    "compute.addresses.delete",
    "compute.addresses.deleteInternal",
    "compute.addresses.get",
    "compute.addresses.use",
    "compute.addresses.useInternal",
    "compute.addresses.setLabels"
  ]
  stage   = "GA"
  project = var.gcp_project_id
}

# Create IAM policy binding for Regional Address access
resource "google_project_iam_binding" "regional_address_create_mapping" {
  project = var.gcp_project_id
  role    = google_project_iam_custom_role.RegionalAddress.name
  members = [
    "serviceAccount:${var.platform_sa_email}",
  ]
  condition {
    title       = "Regional Address write Access"
    description = "Regional Address write Access"
    expression  = "resource.name.startsWith(\"projects/${var.gcp_project_id}/regions/\") && resource.name.contains(\"/addresses/e6data\")"
  }
}

resource "google_project_iam_custom_role" "security_policy" {
  role_id     = "${local.cluster_viewer_role_name}_${random_string.random.result}_security_policy"
  title       = "e6data ${var.workspace_name} security policy ${random_string.random.result}"
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
  role_id     = "${local.workload_role_name}_${random_string.random.result}"
  title       = "e6data ${var.workspace_name} workloadIdentityUser Access ${random_string.random.result}"
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
resource "google_project_iam_binding" "workspace_ksa_mapping" {
  project = var.gcp_project_id
  role    = google_project_iam_custom_role.workloadIdentityUser.name
  members = [
    "serviceAccount:${var.gcp_project_id}.svc.id.goog[${var.kubernetes_namespace}/${var.workspace_name}]",
  ]
}

resource "google_project_iam_custom_role" "targetpoolAccess" {
  role_id     = "${local.target_pool_role_name}_${random_string.random.result}"
  title       = "e6data ${var.workspace_name} targetpoolAccess ${random_string.random.result}"
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

# Certificate Manager Viewer role binding for platform service account
resource "google_project_iam_member" "platform_cert_manager_viewer" {
  project = var.gcp_project_id
  role    = "roles/certificatemanager.viewer"
  member  = "serviceAccount:${var.platform_sa_email}"
}

# Custom role for CRD and third party objects permissions
resource "google_project_iam_custom_role" "crd_list_role" {
  role_id     = "e6data_${local.workspace_role_name}_crd_list_${random_string.random.result}"
  title       = "e6data ${var.workspace_name} CRD List Access ${random_string.random.result}"
  description = "Custom role for managing CustomResourceDefinitions and third party objects"
  permissions = [
    "container.customResourceDefinitions.list",
    "container.thirdPartyObjects.create",
    "container.thirdPartyObjects.delete",
    "container.thirdPartyObjects.get",
    "container.thirdPartyObjects.list",
    "container.thirdPartyObjects.update"
  ]
  stage   = "GA"
  project = var.gcp_project_id
}

# IAM binding for CRD list role to platform service account
resource "google_project_iam_binding" "platform_crd_list_binding" {
  project = var.gcp_project_id
  role    = google_project_iam_custom_role.crd_list_role.name
  members = [
    "serviceAccount:${var.platform_sa_email}",
  ]
}