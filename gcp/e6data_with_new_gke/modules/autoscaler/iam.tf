resource "google_service_account" "cluster_autoscaler" {
  account_id   = "${var.cluster_name}-ca-sa"
  display_name = "Kubernetes Cluster Autoscaler Service Account"
}

resource "google_project_iam_binding" "compute_instance_admin" {
  project = var.gcp_project_id
  role    = "roles/compute.instanceAdmin.v1"

  members = [
    "serviceAccount:${google_service_account.cluster_autoscaler.email}"
  ]
}

resource "kubernetes_service_account" "cluster_autoscaler" {
  metadata {
    name      = var.service_account_name
    namespace = var.namespace

    annotations = {
      "iam.gke.io/gcp-service-account" = "${google_service_account.cluster_autoscaler.email}"
    }
  }
}

resource "google_service_account_iam_binding" "workload_identity_binding" {
  service_account_id = google_service_account.cluster_autoscaler.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.gcp_project_id}.svc.id.goog[${var.namespace}/${kubernetes_service_account.cluster_autoscaler.metadata.0.name}]"
  ]
}