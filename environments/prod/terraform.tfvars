filestore_name="starlake-store"
db_name="starlake"
starlake_user="starlake"
firewall_name="cloud-sql-ingress"
whitelisted_ip="169.150.218.35"
cloud_sql_client_name="sql-client"
firewall_target_tags=["cloud-sql"]
org_id="180088027263"
billing_account="018933-77C2BB-98D2AA"
main_project_id = "starlake-325712"
main_network_name = "starlake-network-v2"
region = "europe-west1"
filestore_share_name="projects"
project = {
      name       = "starlake-prod"
      project_id = "starlake-prod-990072"
      region     = "europe-west1"
      location   = "europe-west1-b"
    }  
ui_vars={
    NODE_ENV               = "production"
    UI_URL                 = "https://app.starlake.ai"
    FILESTORE_MNT_DIR      = "/mnt/filestore/projects"
    FILESTORE_SHARE_NAME   = "projects"
    domain                 = "app.starlake.ai"
    service_name           = "starlake-ui"
    image                  = "europe-west1-docker.pkg.dev/starlake-325712/starlake-docker-repo/starlake-ui-v2:latest"
    NEXT_PUBLIC_SL_UI_DEMO = "false"
  }
  api_vars={
    image                         = "europe-west1-docker.pkg.dev/starlake-325712/starlake-docker-repo/starlake-api-v2:latest",
    service_name                  = "starlake-api",
    SL_API_PROJECT_ROOT           = "/mnt/filestore/projects"
    SL_API_HTTP_PORT              = "9000"
    SL_API_HTTP_INTERFACE         = "0.0.0.0"
    SL_API_HTTP_FRONT_URL         = "https://app.starlake.ai"
    SL_API_JDBC_USER              = "postgres"
    SL_API_GIT_COMMAND_ROOT       = "/git"
    SL_FS                         = "file://"
    GCLOUD_SERVICE_ACCOUNT        = "500278873136-compute@developer.gserviceaccount.com"
    GCLOUD_PROJECT                = "starlake-325712"
    FILESTORE_MNT_DIR             = "/mnt/filestore/projects"
    FILESTORE_SHARE_NAME          = "projects"
    SL_API_LOG_LEVEL              = "INFO"
    SL_API_SAAS_DUCKDB_MODE       = "true"
    SL_API_AI_URL                 = "https://ollama-starlakeai-500278873136.europe-west1.run.app"
    SL_DUCKDB_MODE                = "false"
    SL_API_STARLAKE_CORE_PATH     = "/app/starlake/starlake"
    SL_API_MAIL_HOST              = "smtp.sendgrid.net"
    SL_API_MAIL_PORT              = "587"
    SL_API_MAIL_USER              = "apikey"
    SL_API_MAIL_FROM              = "contact@starlake.ai"
    SL_API_JDBC_DRIVER            = "org.postgresql.Driver"
    SL_API_HTTP_URL               = "https://app.starlake.ai"
    SL_SPARK_NO_CATALOG           = "true"
    SL_API_AI_MODEL               = "llama3:8b"
    SL_API_STARLAKE_CORE_ENV_VARS = "SPARK_DRIVER_MEMORY=1g,SPARK_MASTER_URL=local[*],SL_SPARK_NO_CATALOG=true"
    SL_API_MODE                   = "ALL"
    SL_SPARK_WAREHOUSE_IS_ACTIVE  = "false"
    SL_AUTO_EXPORT_SCHEMA         = "true"
    SL_API_DAG_FOLDER             = "/mnt/filestore/projects/dags"
    SL_API_MAX_USER_SPACE_MB      = "100"
    SL_API_ORCHESTRATOR_URL       = ""
    SL_API_AIRFLOW_PRIVATE_URL    = ""
    volume_mounts = {
      name       = "cloudsql",
      mount_path = "/cloudsql"
    },
    ports = {
      container_port = 9000,
      name           = "http1"
    },
    resources = {
      cpu_idle          = true,
      startup_cpu_boost = true
      limits = {
        cpu    = "4000m",
        memory = "16Gi"
      }
    }
  }
  api_services=[
    "servicenetworking.googleapis.com",
    "sqladmin.googleapis.com",
    "secretmanager.googleapis.com",
    "run.googleapis.com",
    "file.googleapis.com",
    "vpcaccess.googleapis.com",
    "compute.googleapis.com"
  ]
  cloud_sql_instance ={
    name    = "private-starlake-api"
    version = "POSTGRES_14"
    cpu     = 2
    memory  = 8
    disk = {
      size       = 100
      autoresize = true
    }
    backup = {
      location = "eu"
      retained = 7
    }
    maintenance = {
      hour = 0
    }
  }
  proxy_subnet = {
    name   = "proxy-subnet"
    subnet = "10.12.0.0/24"
  }
  vpc_access_subnet = {
    name   = "vpc-network-subnet"
    subnet = "10.10.0.0/28"
  }