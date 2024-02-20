output "network_self_link" {
  value = data.google_compute_network.network.self_link
}

output "subnetwork_self_link" {
  value = google_compute_subnetwork.subnetwork.self_link
}