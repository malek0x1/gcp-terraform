terraform {
  required_providers {
    google      = {}
    google-beta = {}
    random      = {}
    local = {
      source = "hashicorp/local"
    }
    null = {
      source = "hashicorp/null"
    }
    http = {
      source = "hashicorp/http"
    }
    tls = {
      source = "hashicorp/tls"
    }
  }
}
