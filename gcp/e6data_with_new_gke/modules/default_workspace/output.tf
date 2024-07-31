output "workspace_gcs_bucket_name" {
  value = google_storage_bucket.workspace_bucket.name
}

output "buckets_read_role_name" {
  value = google_project_iam_custom_role.workspace_read_role.name
}

output "buckets_write_role_name" {
  value = google_project_iam_custom_role.workspace_write_role.name
}

output "workloadIdentityUser_role_name" {
  value = google_project_iam_custom_role.workloadIdentityUser.name
}

