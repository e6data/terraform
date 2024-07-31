locals{

  workspaces_with_sa = [for ws in var.workspaces : ws if ws.serviceaccount_create]
  service_accounts = {
    for idx, workspace in local.workspaces_with_sa : 
    workspace.name => google_service_account.workspace_sa[idx].email
  }
  
    workspaces_with_star_buckets = {
    for idx, ws in var.workspaces : idx => ws
    if contains(ws.buckets, "*")
  }
  
  workspaces_without_star_buckets = {
    for idx, ws in var.workspaces : idx => ws
    if !contains(ws.buckets, "*")
  }

  workspace_bucket_bindings = flatten([
    for idx, workspace in local.workspaces_without_star_buckets :
    [
      for bucket in workspace.buckets :
      {
        workspace = workspace
        bucket    = bucket
        idx       = idx
      }
    ]
  ])

  member_emails = {
    for idx, workspace in var.workspaces :
    idx => workspace.serviceaccount_create ? google_service_account.workspace_sa[idx].email : workspace.serviceaccount_email
  }

} 

resource "random_string" "random" {
  count    = length(var.workspaces)
  length  = 5
  special = false
  lower   = true
  upper   = false
}