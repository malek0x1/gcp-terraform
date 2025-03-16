// create the main network
resource "google_compute_network" "main_network" {
  project                 = var.project_id
  name                    = var.main_network_name
  auto_create_subnetworks = false
}
// vpc access connector subnet
resource "google_compute_subnetwork" "vpc_access_network_subnet" {
  project                  = var.project_id
  name                     = var.vpc_access_subnet.name
  ip_cidr_range            = var.vpc_access_subnet.subnet
  network                  = google_compute_network.main_network.id
  region                   = var.region
  private_ip_google_access = true
}
// proxy subnet CE
resource "google_compute_subnetwork" "proxy_subnet" {
  project       = var.project_id
  name          = var.proxy_subnet.name
  ip_cidr_range = var.proxy_subnet.subnet
  network       = google_compute_network.main_network.id
  region        = var.region
}

// vpc access connector
resource "google_vpc_access_connector" "vpc_connector" {
  project = var.project_id
  name    = "vpc-connector"
  region  = var.region
  subnet {
    name = google_compute_subnetwork.vpc_access_network_subnet.name
  }
  machine_type  = "e2-micro"
  min_instances = 2
  max_instances = 10
}
// reserve private ip range
resource "google_compute_global_address" "private_sql_address" {
  name          = "private-sql-address"
  provider      = google-beta
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  project       = var.project_id
  network       = google_compute_network.main_network.id

}
// establish vpc peering
resource "google_service_networking_connection" "private_sql_connection" {
  provider                = google-beta
  network                 = google_compute_network.main_network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_sql_address.name]
}
// config routes
resource "google_compute_network_peering_routes_config" "peering_sql_routes" {
  project              = var.project_id
  peering              = google_service_networking_connection.private_sql_connection.peering
  network              = google_compute_network.main_network.name
  import_custom_routes = true
  export_custom_routes = true
}
