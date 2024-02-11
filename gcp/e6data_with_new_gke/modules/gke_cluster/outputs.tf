output "gke_cluster_endpoint" {
  value = google_container_cluster.gke_cluster.endpoint
}

output "gke_cluster_client_certificate" {
  value = google_container_cluster.gke_cluster.master_auth[0].client_certificate
}

output "gke_cluster_client_key" {
  value = google_container_cluster.gke_cluster.master_auth[0].client_key
}

output "gke_cluster_cluster_ca_certificate" {
  value = google_container_cluster.gke_cluster.master_auth[0].cluster_ca_certificate
}

output "gke_cluster_id" {
  value = google_container_cluster.gke_cluster.id
}

output "google_client_config_access_token" {
  value = data.google_client_config.default.access_token
}
