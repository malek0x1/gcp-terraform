
// fetch noauth policy
data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}
// fetch project number
data "google_project" "project" {
  project_id = var.project_id
}
// fetch service account email
data "google_service_account" "default" {
  project    = var.project_id
  account_id = "${data.google_project.project.number}-compute@developer.gserviceaccount.com"
}
// starlake api cloud run
resource "google_cloud_run_v2_service" "starlake_api" {
  project             = var.project_id
  name                = var.api_vars.service_name
  location            = var.region
  ingress             = "INGRESS_TRAFFIC_INTERNAL_ONLY"
  deletion_protection = false

  template {
    max_instance_request_concurrency = 80
    service_account                  = data.google_service_account.default.email
    timeout                          = "300s"
    execution_environment            = "EXECUTION_ENVIRONMENT_GEN2"
    volumes {
      name = "cloudsql"
      cloud_sql_instance {
        instances = [var.connection_name]
      }
    }
    containers {
      image = var.api_vars.image

      env {
        name  = "SL_API_HTTP_PORT"
        value = var.api_vars.SL_API_HTTP_PORT
      }

      env {
        name  = "SL_API_PROJECT_ROOT"
        value = var.api_vars.SL_API_PROJECT_ROOT
      }

      env {
        name  = "SL_API_HTTP_INTERFACE"
        value = var.api_vars.SL_API_HTTP_INTERFACE
      }
      env {
        name  = "SL_API_HTTP_URL"
        value = var.api_vars.SL_API_HTTP_URL
      }
      env {
        name  = "SL_API_HTTP_FRONT_URL"
        value = var.api_vars.SL_API_HTTP_FRONT_URL
      }
      env {
        name  = "SL_API_JDBC_USER"
        value = var.jdbc_user
      }
      env {
        name  = "SL_API_JDBC_PASSWORD"
        value = var.jdbc_password
      }
      env {
        name  = "SL_API_JDBC_URL"
        value = "jdbc:postgresql:///${var.db_name}?cloudSqlInstance=${var.connection_name}&socketFactory=com.google.cloud.sql.postgres.SocketFactory"
      }
      env {
        name  = "SL_API_GOOGLE_CLIENT_ID"
        value = var.SL_GOOGLE_CLIENT_ID
      }
      env {
        name  = "SL_API_GOOGLE_CLIENT_SECRET"
        value = var.SL_API_GOOGLE_CLIENT_SECRET
      }
      env {
        name  = "SL_API_GIT_COMMAND_ROOT"
        value = var.api_vars.SL_API_GIT_COMMAND_ROOT
      }
      env {
        name  = "SL_FS"
        value = var.api_vars.SL_FS
      }
      env {
        name  = "GCLOUD_SERVICE_ACCOUNT"
        value = data.google_service_account.default.email
      }
      env {
        name  = "GCLOUD_PROJECT"
        value = var.project_id
      }
      env {
        name  = "FILESTORE_IP_ADDRESS"
        value = var.filestore_ip
      }
      env {
        name  = "FILESTORE_MNT_DIR"
        value = var.api_vars.FILESTORE_MNT_DIR
      }
      env {
        name  = "FILESTORE_SHARE_NAME"
        value = var.api_vars.FILESTORE_SHARE_NAME
      }
      env {
        name  = "SL_API_LOG_LEVEL"
        value = var.api_vars.SL_API_LOG_LEVEL
      }
      env {
        name  = "SL_API_SERVER_SECRET"
        value = var.SL_API_SERVER_SECRET
      }
      env {
        name  = "SL_API_SAAS_DUCKDB_MODE"
        value = var.api_vars.SL_API_SAAS_DUCKDB_MODE
      }
      env {
        name  = "SL_API_AI_URL"
        value = var.api_vars.SL_API_AI_URL
      }
      env {
        name  = "SL_DUCKDB_MODE"
        value = var.api_vars.SL_DUCKDB_MODE
      }
      env {
        name  = "SL_API_STARLAKE_CORE_PATH"
        value = var.api_vars.SL_API_STARLAKE_CORE_PATH
      }
      env {
        name  = "SL_API_MAIL_HOST"
        value = var.api_vars.SL_API_MAIL_HOST
      }
      env {
        name  = "SL_API_MAIL_PORT"
        value = var.api_vars.SL_API_MAIL_PORT
      }
      env {
        name  = "SL_API_MAIL_USER"
        value = var.api_vars.SL_API_MAIL_USER
      }
      env {
        name  = "SL_API_MAIL_PASSWORD"
        value = var.SL_API_MAIL_PASSWORD
      }
      env {
        name  = "SL_API_MAIL_FROM"
        value = var.api_vars.SL_API_MAIL_FROM
      }
      env {
        name  = "SL_API_JDBC_DRIVER"
        value = var.api_vars.SL_API_JDBC_DRIVER
      }
      env {
        name  = "SL_SPARK_NO_CATALOG"
        value = var.api_vars.SL_SPARK_NO_CATALOG
      }
      env {
        name  = "SL_API_AI_URL"
        value = var.api_vars.SL_API_AI_URL
      }
      env {
        name  = "SL_API_AI_MODEL"
        value = var.api_vars.SL_API_AI_MODEL
      }
      env {
        name  = "SL_API_STARLAKE_CORE_ENV_VARS"
        value = var.api_vars.SL_API_STARLAKE_CORE_ENV_VARS
      }
      env {
        name  = "SL_API_MODE"
        value = var.api_vars.SL_API_MODE
      }
      env {
        name  = "SL_SPARK_WAREHOUSE_IS_ACTIVE"
        value = var.api_vars.SL_SPARK_WAREHOUSE_IS_ACTIVE
      }
      env {
        name  = "SL_SPARK_NO_CATALOG"
        value = var.api_vars.SL_SPARK_NO_CATALOG
      }
      env {
        name  = "SL_AUTO_EXPORT_SCHEMA"
        value = var.api_vars.SL_AUTO_EXPORT_SCHEMA
      }
      env {
        name  = "SL_API_DAG_FOLDER"
        value = var.api_vars.SL_API_DAG_FOLDER
      }

      env {
        name  = "SL_API_MAX_USER_SPACE_MB"
        value = var.api_vars.SL_API_MAX_USER_SPACE_MB
      }
      env {
        name  = "SL_API_ORCHESTRATOR_URL"
        value = var.api_vars.SL_API_ORCHESTRATOR_URL
      }
      env {
        name  = "SL_API_AIRFLOW_PRIVATE_URL"
        value = var.api_vars.SL_API_AIRFLOW_PRIVATE_URL
      }

      volume_mounts {
        name       = "cloudsql"
        mount_path = "/cloudsql"
      }
      ports {
        container_port = 9000
        name           = "http1"
      }
      resources {
        cpu_idle          = true
        startup_cpu_boost = true
        limits = {
          cpu    = "4000m"
          memory = "16Gi"
        }
      }
    }
    vpc_access {
      connector = var.vpc_access_connector
      egress    = "PRIVATE_RANGES_ONLY"

    }
    scaling {
      max_instance_count = 5
      min_instance_count = 1
    }
  }

  timeouts {}

}

resource "google_cloud_run_v2_service_iam_policy" "starlake_api_noauth" {
  project     = var.project_id
  location    = var.region
  name        = google_cloud_run_v2_service.starlake_api.name
  policy_data = data.google_iam_policy.noauth.policy_data
}


resource "google_cloud_run_v2_service" "starlake_ui" {
  project  = var.project_id
  name     = var.ui_vars.service_name
  location = var.region
  ingress  = "INGRESS_TRAFFIC_ALL"
  client   = "cloud-console"

  annotations = {
    "client.knative.dev/user-image" = var.ui_vars.image
  }
  template {
    max_instance_request_concurrency = 80
    service_account                  = data.google_service_account.default.email
    timeout                          = "300s"
    execution_environment            = "EXECUTION_ENVIRONMENT_GEN2"

    containers {
      image = var.ui_vars.image

      env {
        name  = "NODE_ENV"
        value = var.ui_vars.NODE_ENV
      }

      env {
        name  = "API_URL"
        value = google_cloud_run_v2_service.starlake_api.uri
      }
      env {
        name  = "UI_URL"
        value = var.ui_vars.UI_URL
      }
      env {
        name  = "FILESTORE_MNT_DIR"
        value = var.ui_vars.FILESTORE_MNT_DIR
      }
      env {
        name  = "FILESTORE_SHARE_NAME"
        value = var.ui_vars.FILESTORE_SHARE_NAME
      }
      env {
        name  = "FILESTORE_IP_ADDRESS"
        value = var.filestore_ip
      }
      env {
        name  = "NEXT_PUBLIC_SL_UI_DEMO"
        value = var.ui_vars.NEXT_PUBLIC_SL_UI_DEMO
      }
      ports {
        container_port = 80
        name           = "http1"
      }
      resources {
        cpu_idle = true
        limits = {
          cpu    = "1000m"
          memory = "512Mi"
        }
      }
    }
    vpc_access {
      connector = var.vpc_access_connector
      egress    = "ALL_TRAFFIC"
    }

    scaling {
      max_instance_count = 3
      min_instance_count = 1
    }
  }

  timeouts {}

  depends_on = [google_cloud_run_v2_service.starlake_api]
}

resource "google_cloud_run_v2_service_iam_policy" "starlake_ui_noauth" {
  project     = var.project_id
  location    = var.region
  name        = google_cloud_run_v2_service.starlake_ui.name
  policy_data = data.google_iam_policy.noauth.policy_data
}

# resource "google_cloud_run_domain_mapping" "starlake_ui_domain" {
#   project  = var.project_id
#   location = var.region
#   name     = var.ui_vars.domain

#   metadata {
#     namespace = var.project_id
#   }

#   spec {
#     route_name = google_cloud_run_v2_service.starlake_ui.name
#   }
# }
