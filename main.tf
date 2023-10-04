terraform {
  required_version = ">= 0.13.1"

  required_providers {
    shoreline = {
      source  = "shorelinesoftware/shoreline"
      version = ">= 1.11.0"
    }
  }
}

provider "shoreline" {
  retries = 2
  debug = true
}

module "password_authentication_failure_for_postgres_user" {
  source    = "./modules/password_authentication_failure_for_postgres_user"

  providers = {
    shoreline = shoreline
  }
}