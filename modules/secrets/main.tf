// get project details
data "google_project" "project" {
  project_id = var.project_id
}
# Project's compute service account
data "google_service_account" "default" {
  project    = var.project_id
  account_id = "${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}

# create secrets
resource "google_secret_manager_secret" "secret" {
  for_each  = var.secrets
  project   = var.project_id
  secret_id = each.key
  replication {
    user_managed {
      replicas {
        location = var.region
      }
    }
  }
}

resource "google_secret_manager_secret_version" "secret_version" {
  for_each    = var.secrets
  secret      = google_secret_manager_secret.secret[each.key].id
  secret_data = each.value.secret_data

}
// grant service account access to secrets
resource "google_secret_manager_secret_iam_member" "secret_access" {
  for_each  = var.secrets
  secret_id = google_secret_manager_secret.secret[each.key].id
  role      = "roles/secretmanager.secretAccessor"
  member    = data.google_service_account.default.member
  project   = var.project_id
}
