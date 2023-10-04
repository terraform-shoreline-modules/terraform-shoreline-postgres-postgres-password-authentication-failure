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

module "generic_title_password_authentication_failure_for_postgres_user" {
  source    = "./modules/generic_title_password_authentication_failure_for_postgres_user"

  providers = {
    shoreline = shoreline
  }
}