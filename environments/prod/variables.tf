variable "project" {
  description = "prod project"
  type = object({
    name       = string
    project_id = string
    region     = string
    location   = string
  })
}
variable "region" {
  type = string
}
variable "main_project_id" {
  description = "The GCP region to deploy resources to"
}
variable "org_id" {
  type = string
}
variable "billing_account" {
  type = string
}
variable "filestore_name" {
  type = string
}
variable "filestore_share_name" {
  type = string
}
variable "db_name" {
  type = string
}
variable "starlake_user" {
  type        = string
  description = "starlake database user"
}

variable "firewall_name" {
  type        = string
  description = "firewall name"
}
variable "firewall_target_tags" {
  type        = list(string)
  description = "firewall target tags"
}
variable "cloud_sql_client_name" {
  type        = string
  description = "name of the compute instance used to initialize the database"
}
variable "whitelisted_ip" {
  description = "whitelisted ip list"
}
variable "main_network_name" {
  type = string
}
variable "SL_GOOGLE_CLIENT_ID" {
  type = string
}
variable "SL_API_GOOGLE_CLIENT_SECRET" {
  type = string
}
variable "SL_API_SERVER_SECRET" {
  type = string
}
variable "SL_API_MAIL_PASSWORD" {
  type = string
}
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

variable "api_services" {
  type = list(string)
}

variable "cloud_sql_instance" {
  type = object({
    version = string
    name    = string
    cpu     = number
    memory  = number
    disk = object({
      size       = number
      autoresize = bool
    })
    backup = object({
      location = string
      retained = number
    })
    maintenance = object({
      hour = number
    })
  })
  description = "cloud sql instance configuration"
}


variable "vpc_access_subnet" {
  description = "VPC access subnet configuration"
  type = object({
    name   = string
    subnet = string
  })

}

variable "proxy_subnet" {
  description = "Proxy subnet configuration"
  type = object({
    name   = string
    subnet = string
  })

}
