output "connection_name" {
  value = google_sql_database_instance.private_starlake_api.connection_name
}
output "db_name" {
  value = google_sql_database.private_starlake_database.name
}

output "database_user" {
  value = google_sql_user.private_starlake_user.name
}

output "database_password" {
  value     = google_sql_user.private_starlake_user.password
  sensitive = true
}
