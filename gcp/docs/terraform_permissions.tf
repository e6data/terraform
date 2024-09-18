variable "project_id" {
  description = "The ID of the project to create resources in."
  type        = string
}

variable "region" {
  description = "The region to create resources in."
  type        = string
  default     = "us-central1"
}

resource "google_project_iam_custom_role" "custom_role" {
  role_id     = "CustomRoleForSpecificPermissions"
  title       = "Custom Role For Specific Permissions"
  description = "A custom role with specific permissions."
  permissions = [
    "cloudkms.cryptoKeyVersions.destroy",
    "cloudkms.cryptoKeyVersions.list",
    "cloudkms.cryptoKeys.create",
    "cloudkms.cryptoKeys.get",
    "cloudkms.cryptoKeys.getIamPolicy",
    "cloudkms.cryptoKeys.list",
    "cloudkms.cryptoKeys.setIamPolicy",
    "cloudkms.cryptoKeys.update",
    "cloudkms.keyRings.create",
    "cloudkms.keyRings.deleteTagBinding",
    "cloudkms.keyRings.get",
    "cloudkms.keyRings.getIamPolicy",
    "cloudkms.keyRings.setIamPolicy",
    "compute.instanceGroupManagers.get",
    "compute.networks.access",
    "compute.networks.create",
    "compute.networks.createTagBinding",
    "compute.networks.delete",
    "compute.networks.deleteTagBinding",
    "compute.networks.get",
    "compute.networks.list",
    "compute.networks.removePeering",
    "compute.networks.update",
    "compute.networks.updatePolicy",
    "compute.networks.use",
    "compute.routers.create",
    "compute.routers.delete",
    "compute.routers.get",
    "compute.routers.update",
    "compute.subnetworks.create",
    "compute.subnetworks.createTagBinding",
    "compute.subnetworks.delete",
    "compute.subnetworks.deleteTagBinding",
    "compute.subnetworks.get",
    "compute.subnetworks.getIamPolicy",
    "compute.subnetworks.list",
    "compute.subnetworks.update",
    "compute.zones.list",
    "iam.roles.create",
    "iam.roles.delete",
    "iam.roles.get",
    "iam.roles.list",
    "iam.serviceAccounts.actAs",
    "iam.serviceAccounts.create",
    "iam.serviceAccounts.delete",
    "iam.serviceAccounts.disable",
    "iam.serviceAccounts.enable",
    "iam.serviceAccounts.get",
    "iam.serviceAccounts.getAccessToken",
    "iam.serviceAccounts.getIamPolicy",
    "iam.serviceAccounts.list",
    "iam.serviceAccounts.setIamPolicy",
    "iam.serviceAccounts.update",
    "resourcemanager.projects.get",
    "resourcemanager.projects.getIamPolicy",
    "resourcemanager.projects.setIamPolicy",
    "serviceusage.services.get",
    "serviceusage.services.list",
    "storage.buckets.create",
    "storage.buckets.delete",
    "storage.buckets.get"
  ]
  project = var.project_id
}

resource "google_service_account" "custom_role_sa" {
  account_id   = "custom-role-sa"
  display_name = "Custom Role Service Account"
  project      = var.project_id
}

resource "google_project_iam_binding" "custom_role_binding" {
  project = var.project_id
  role    = "projects/${var.project_id}/roles/CustomRoleForSpecificPermissions"

  members = [
    "serviceAccount:${google_service_account.custom_role_sa.email}"
  ]
}

resource "google_project_iam_binding" "kubernetes_engine_admin_binding" {
  project = var.project_id
  role    = "roles/container.admin"

  members = [
    "serviceAccount:${google_service_account.custom_role_sa.email}"
  ]
}
