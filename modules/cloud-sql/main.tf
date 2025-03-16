// create cloud sql instance
resource "google_sql_database_instance" "private_starlake_api" {
  provider         = google-beta
  name             = var.cloud_sql_instance.name
  database_version = var.cloud_sql_instance.version
  project          = var.project_id
  region           = var.region
  settings {
    tier                        = "db-custom-${var.cloud_sql_instance.cpu}-${var.cloud_sql_instance.memory * 1024}"
    deletion_protection_enabled = false
    disk_autoresize             = var.cloud_sql_instance.disk.autoresize
    disk_type                   = "PD_SSD"
    disk_size                   = var.cloud_sql_instance.disk.size
    backup_configuration {
      enabled                        = true
      location                       = var.cloud_sql_instance.backup.location
      point_in_time_recovery_enabled = "true"
      backup_retention_settings {
        retained_backups = var.cloud_sql_instance.backup.retained
        retention_unit   = "COUNT"
      }
    }
    ip_configuration {
      ipv4_enabled    = false
      private_network = var.main_network_id
    }
  }
  deletion_protection = true
}

resource "google_sql_database" "private_starlake_database" {
  project   = var.project_id
  name      = var.db_name
  instance  = google_sql_database_instance.private_starlake_api.name
  charset   = "UTF8"
  collation = "en_US.UTF8"
}
resource "random_password" "private_starlake_password" {
  length  = 16
  special = true
  lower   = true
  upper   = true
  numeric = true
}

resource "local_file" "password" {
  content         = random_password.private_starlake_password.result
  file_permission = "0700"
  filename        = "${path.module}/.password"
}

resource "google_sql_user" "private_starlake_user" {
  project  = var.project_id
  name     = var.starlake_user
  instance = google_sql_database_instance.private_starlake_api.name
  password = random_password.private_starlake_password.result
  timeouts {}
}

module "secrets" {
  source     = "../secrets"
  region     = var.region
  project_id = var.project_id
  secrets = {
    "cloud_sql_database_user_secret" = {
      secret_data = google_sql_user.private_starlake_user.name
    },
    "cloud_sql_database_password_secret" = {
      secret_data = google_sql_user.private_starlake_user.password
    },
    "cloud_sql_database_url_secret" = {
      secret_data = "jdbc:postgresql:///${var.db_name}?cloudSqlInstance=${google_sql_database_instance.private_starlake_api.connection_name}&socketFactory=com.google.cloud.sql.postgres.SocketFactory"
    },
    "google_client_id_secret" = {
      secret_data = var.SL_GOOGLE_CLIENT_ID
    },
    "google_client_secret_secret" = {
      secret_data = var.SL_API_GOOGLE_CLIENT_SECRET
    }
  }
  depends_on = [
    google_compute_instance.private_starlake_client,
    google_sql_user.private_starlake_user,
    google_sql_database.private_starlake_database
  ]
}

data "google_project" "project" {
  project_id = var.project_id
}
data "google_service_account" "default" {
  project    = var.project_id
  account_id = "${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}

data "google_client_openid_userinfo" "me" {}

// ssh generate key
resource "tls_private_key" "private_starlake_ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "private_ssh_key" {
  content         = tls_private_key.private_starlake_ssh_key.private_key_pem
  file_permission = "0700"
  filename        = "${path.module}/.id_rsa"
}

resource "local_file" "public_ssh_key" {
  content         = tls_private_key.private_starlake_ssh_key.public_key_pem
  file_permission = "0700"
  filename        = "${path.module}/.id_rsa.pub"
}
// add firewall rule
resource "google_compute_firewall" "private_starlake_firewall" {
  name    = var.firewall_name
  network = var.main_network_name
  project = var.project_id
  allow {
    protocol = "tcp"
    ports    = ["5432", "22", "5431"]
  }
  source_ranges = [var.whitelisted_ip]
  target_tags   = var.firewall_target_tags
}


# read template file
data "template_file" "cloud_sql_proxy_service" {
  template = file("${path.module}/templates/cloud-sql-proxy.service.tpl")
  vars = {
    cloud_sql_connection_name = google_sql_database_instance.private_starlake_api.connection_name
  }
}

resource "google_compute_instance" "private_starlake_client" {
  name         = var.cloud_sql_client_name
  machine_type = "f1-micro"
  project      = var.project_id
  zone         = var.zone

  tags = google_compute_firewall.private_starlake_firewall.target_tags

  metadata = {
    ssh-keys = "${data.google_client_openid_userinfo.me.email}:${trimspace(tls_private_key.private_starlake_ssh_key.public_key_openssh)}"
  }

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    subnetwork         = var.proxy_subnet_name
    subnetwork_project = var.project_id

    access_config {
      // Ephemeral public IP
    }
  }

  service_account {
    email  = data.google_service_account.default.email
    scopes = ["cloud-platform"]
  }

  timeouts {}


}

resource "null_resource" "provisioning" {
  depends_on = [google_compute_instance.private_starlake_client]

  provisioner "file" {
    content     = data.template_file.cloud_sql_proxy_service.rendered
    destination = "/tmp/cloud-sql-proxy.service"
    connection {
      type        = "ssh"
      user        = data.google_client_openid_userinfo.me.email
      host        = google_compute_instance.private_starlake_client.network_interface[0].access_config[0].nat_ip
      private_key = tls_private_key.private_starlake_ssh_key.private_key_pem
    }
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = data.google_client_openid_userinfo.me.email
      host        = google_compute_instance.private_starlake_client.network_interface[0].access_config[0].nat_ip
      private_key = tls_private_key.private_starlake_ssh_key.private_key_pem
    }
    inline = [
      "sudo sh -c 'echo deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main > /etc/apt/sources.list.d/pgdg.list'",
      "sudo apt -y install gnupg2 wget",
      "sudo wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add",
      "sudo apt -y update",
      "sudo apt -y install postgresql-client-14",
      "sudo wget https://storage.googleapis.com/cloud-sql-connectors/cloud-sql-proxy/v2.0.0/cloud-sql-proxy.linux.amd64 -O /usr/local/bin/cloud-sql-proxy",
      "sudo chmod +x /usr/local/bin/cloud-sql-proxy",
      "sudo cp /tmp/cloud-sql-proxy.service /lib/systemd/system/cloud-sql-proxy.service",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable cloud-sql-proxy.service",
      "sudo systemctl start cloud-sql-proxy.service"
    ]
  }
}
