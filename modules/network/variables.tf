variable "main_network_name" {
  type = string
}

variable "project_id" {
  type = string
}

variable "region" {
  type = string
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
