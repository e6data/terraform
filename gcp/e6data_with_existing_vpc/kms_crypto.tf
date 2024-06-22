resource "google_kms_key_ring" "key_ring" {
  name     = "e6data-${var.cluster_name}-${var.gcp_project_id}-${random_string.crypto_random.id}-key-ring"
  project  = var.gcp_project_id
  location = var.gcp_region
}

resource "google_kms_crypto_key" "crypto_key" {
  name            = "e6data-${var.cluster_name}-${var.gcp_project_id}-${random_string.crypto_random.id}-crypto-key"
  key_ring        = google_kms_key_ring.key_ring.id
  rotation_period = "100000s"
}

resource "random_string" "crypto_random" {
  length  = 3
  upper   = false
  special = false
  numeric = false
}

resource "google_kms_key_ring_iam_binding" "key_ring" {
  key_ring_id = google_kms_key_ring.key_ring.id
  role        = "roles/cloudkms.admin"

  members = [
    "serviceAccount:service-${data.google_project.current.number}@container-engine-robot.iam.gserviceaccount.com",
  ]
}

resource "google_kms_key_ring_iam_binding" "key_ring_encrypter_decrypter" {
  key_ring_id = google_kms_key_ring.key_ring.id
  role        = "roles/cloudkms.cryptoKeyEncrypterDecrypter"

  members = [
    "serviceAccount:service-${data.google_project.current.number}@container-engine-robot.iam.gserviceaccount.com",
  ]
}
