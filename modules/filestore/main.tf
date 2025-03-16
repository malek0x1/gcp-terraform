// create filestore instance
resource "google_filestore_instance" "instance" {

  name     = var.filestore_name
  project  = var.project_id
  location = var.location
  tier     = "BASIC_HDD"

  file_shares {
    name        = var.filestore_share_name
    capacity_gb = 1024
  }

  networks {
    network = var.network_name
    modes   = ["MODE_IPV4"]
  }
}
