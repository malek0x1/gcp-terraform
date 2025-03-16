variable "project_id" {
  type        = string
  description = "google project id"
}

variable "region" {
  type        = string
  description = "google project localization"
}

# UI ENVS
variable "ui_vars" {
  type = object({
    NODE_ENV               = string
    UI_URL                 = string
    FILESTORE_MNT_DIR      = string
    FILESTORE_SHARE_NAME   = string
    domain                 = string
    service_name           = string
    image                  = string
    NEXT_PUBLIC_SL_UI_DEMO = string
  })
}

variable "api_vars" {
  type = object({
    image                         = string
    service_name                  = string
    SL_API_PROJECT_ROOT           = string
    SL_API_HTTP_PORT              = string
    SL_API_HTTP_INTERFACE         = string
    SL_API_HTTP_FRONT_URL         = string
    SL_API_JDBC_USER              = string
    SL_API_GIT_COMMAND_ROOT       = string
    SL_FS                         = string
    GCLOUD_SERVICE_ACCOUNT        = string
    GCLOUD_PROJECT                = string
    FILESTORE_MNT_DIR             = string
    FILESTORE_SHARE_NAME          = string
    SL_API_LOG_LEVEL              = string
    SL_API_SAAS_DUCKDB_MODE       = string
    SL_API_AI_URL                 = string
    SL_DUCKDB_MODE                = string
    SL_API_STARLAKE_CORE_PATH     = string
    SL_API_MAIL_HOST              = string
    SL_API_MAIL_PORT              = string
    SL_API_MAIL_USER              = string
    SL_API_MAIL_FROM              = string
    SL_API_JDBC_DRIVER            = string
    SL_API_HTTP_URL               = string
    SL_SPARK_NO_CATALOG           = string
    SL_API_AI_MODEL               = string
    SL_API_STARLAKE_CORE_ENV_VARS = string
    SL_API_MODE                   = string
    SL_SPARK_WAREHOUSE_IS_ACTIVE  = string
    SL_AUTO_EXPORT_SCHEMA         = string
    SL_API_DAG_FOLDER             = string
    SL_API_MAX_USER_SPACE_MB      = string
    SL_API_ORCHESTRATOR_URL       = string
    SL_API_AIRFLOW_PRIVATE_URL    = string
    volume_mounts = object({
      name       = string
      mount_path = string
    })
    ports = object({
      container_port = number
      name           = string
    })
    resources = object({
      cpu_idle          = bool
      startup_cpu_boost = bool
      limits = object({
        cpu    = string
        memory = string
      })
    })
  })

}

variable "vpc_access_connector" {
  type        = string
  description = "vpc access connector"
}
variable "connection_name" {
  type        = string
  description = "Connection name"
}

variable "jdbc_user" {
  type        = string
  description = "JDBC user"
}

variable "jdbc_password" {
  type        = string
  description = "JDBC password"
}


variable "filestore_ip" {
  type = string
}
variable "SL_API_MAIL_PASSWORD" {
  type = string
}
variable "SL_API_SERVER_SECRET" {
  type = string
}
variable "SL_API_GOOGLE_CLIENT_SECRET" {
  type = string
}
variable "SL_GOOGLE_CLIENT_ID" {
  type = string
}

variable "db_name" {
  type = string
}

