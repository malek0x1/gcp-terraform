// instead of destructing each for main network
output "main_network" {
  value = google_compute_network.main_network
}


output "proxy_subnet" {
  value = google_compute_subnetwork.proxy_subnet
}
output "vpc_access_connector" {
  value = google_vpc_access_connector.vpc_connector.id
}
