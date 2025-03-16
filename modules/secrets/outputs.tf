output "cloud_sql_database_user_secret" {
  description = "The ID of the Cloud SQL Database User secret"
  value       = google_secret_manager_secret.secret["cloud_sql_database_user_secret"].id
}

output "cloud_sql_database_password_secret" {
  description = "The ID of the Cloud SQL Database Password secret"
  value       = google_secret_manager_secret.secret["cloud_sql_database_password_secret"].id
}

output "google_client_id_secret" {
  description = "The ID of the Google Client ID secret"
  value       = google_secret_manager_secret.secret["google_client_id_secret"].id
}

output "google_client_secret_secret" {
  description = "The ID of the Google Client Secret secret"
  value       = google_secret_manager_secret.secret["google_client_secret_secret"].id
}
