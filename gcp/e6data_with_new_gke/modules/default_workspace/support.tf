# locals{
#     helm_values_file = yamlencode({
#         cloud = {
#         type               = "GCP"
#         oidc_value         = google_service_account.workspace_sa.email
#         control_plane_user = var.control_plane_user
#         }
#     })
# } 