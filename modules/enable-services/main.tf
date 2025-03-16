resource "google_project_service" "apis" {
  for_each                   = toset(var.api_services)
  project                    = var.project_id
  service                    = each.value
  disable_on_destroy         = false
  disable_dependent_services = true
}
