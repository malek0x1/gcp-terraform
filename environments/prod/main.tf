module "enable_services" {
  source       = "../../modules/enable-services"
  project_id   = var.project.project_id
  api_services = var.api_services
}

module "network" {
  source            = "../../modules/network"
  project_id        = var.project.project_id
  region            = var.project.region
  main_network_name = var.main_network_name
  proxy_subnet      = var.proxy_subnet
  vpc_access_subnet = var.vpc_access_subnet

  depends_on = [
    module.enable_services,
  ]
}

module "filestore" {
  source               = "../../modules/filestore"
  project_id           = var.project.project_id
  network_name         = module.network.main_network.name
  location             = var.project.location
  filestore_name       = var.filestore_name
  filestore_share_name = var.filestore_share_name

  depends_on = [
    module.enable_services,
    module.network
  ]
}

module "cloud-sql" {
  source                      = "../../modules/cloud-sql"
  project_id                  = var.project.project_id
  main_network_id             = module.network.main_network.id
  main_network_name           = module.network.main_network.name
  proxy_subnet_name           = module.network.proxy_subnet.name
  SL_GOOGLE_CLIENT_ID         = var.SL_GOOGLE_CLIENT_ID
  SL_API_GOOGLE_CLIENT_SECRET = var.SL_API_GOOGLE_CLIENT_SECRET
  region                      = var.project.region
  zone                        = var.project.location
  db_name                     = var.db_name
  whitelisted_ip              = var.whitelisted_ip
  firewall_name               = var.firewall_name
  starlake_user               = var.starlake_user
  cloud_sql_client_name       = var.cloud_sql_client_name
  firewall_target_tags        = var.firewall_target_tags
  cloud_sql_instance          = var.cloud_sql_instance

  depends_on = [
    module.enable_services,
    module.network,
  ]
}

module "custom_commands" {
  source          = "../../modules/custom-commands"
  main_project_id = var.main_project_id
  project_id      = var.project.project_id
  region          = var.project.region

  depends_on = [
    module.enable_services
  ]
}

module "cloud-run" {
  source     = "../../modules/cloud-run"
  project_id = var.project.project_id
  region     = var.project.region

  vpc_access_connector        = module.network.vpc_access_connector
  connection_name             = module.cloud-sql.connection_name
  jdbc_user                   = module.cloud-sql.database_user
  jdbc_password               = module.cloud-sql.database_password
  filestore_ip                = module.filestore.filestore_ip
  db_name                     = module.cloud-sql.db_name
  SL_GOOGLE_CLIENT_ID         = var.SL_GOOGLE_CLIENT_ID
  SL_API_SERVER_SECRET        = var.SL_API_SERVER_SECRET
  SL_API_MAIL_PASSWORD        = var.SL_API_MAIL_PASSWORD
  SL_API_GOOGLE_CLIENT_SECRET = var.SL_API_GOOGLE_CLIENT_SECRET
  api_vars                    = var.api_vars
  ui_vars                     = var.ui_vars

  depends_on = [
    module.enable_services,
    module.network,
    module.cloud-sql,
    module.custom_commands
  ]
}
