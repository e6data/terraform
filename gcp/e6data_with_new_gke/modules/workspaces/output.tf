# output "workspace_gcs_bucket_name" {
#   value = google_storage_bucket.workspace_bucket.name
# }

output "workspace_bucket_names" {
  value = [for bucket in google_storage_bucket.workspace_bucket : bucket.name]
  description = "The names of the storage buckets created for each workspace."
}
