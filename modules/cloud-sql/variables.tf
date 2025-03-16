variable "main_network_id" {
  type = string
}

variable "project_id" {
  type = string
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

variable "starlake_user" {
  type        = string
  description = "starlake database user"
}

variable "main_network_name" {
  type = string
}
variable "proxy_subnet_name" {
  type = string
}
variable "whitelisted_ip" {
  type = string
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
variable "zone" {
  type        = string
  description = "google project zone"
}

variable "region" {
  type = string

}

variable "db_name" {
  type = string

}
variable "SL_API_GOOGLE_CLIENT_SECRET" {
  type = string
}

variable "SL_GOOGLE_CLIENT_ID" {
  type = string
}
