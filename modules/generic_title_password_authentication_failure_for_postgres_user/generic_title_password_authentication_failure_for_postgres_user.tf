resource "shoreline_notebook" "generic_title_password_authentication_failure_for_postgres_user" {
  name       = "generic_title_password_authentication_failure_for_postgres_user"
  data       = file("${path.module}/data/generic_title_password_authentication_failure_for_postgres_user.json")
  depends_on = [shoreline_action.invoke_check_pg_service,shoreline_action.invoke_db_config_check,shoreline_action.invoke_reset_postgres_password]
}

resource "shoreline_file" "check_pg_service" {
  name             = "check_pg_service"
  input_file       = "${path.module}/data/check_pg_service.sh"
  md5              = filemd5("${path.module}/data/check_pg_service.sh")
  description      = "Next Step"
  destination_path = "/agent/scripts/check_pg_service.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "db_config_check" {
  name             = "db_config_check"
  input_file       = "${path.module}/data/db_config_check.sh"
  md5              = filemd5("${path.module}/data/db_config_check.sh")
  description      = "The database configuration settings have been changed or misconfigured, leading to authentication issues."
  destination_path = "/agent/scripts/db_config_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "reset_postgres_password" {
  name             = "reset_postgres_password"
  input_file       = "${path.module}/data/reset_postgres_password.sh"
  md5              = filemd5("${path.module}/data/reset_postgres_password.sh")
  description      = "Verify that the user is entering the correct login credentials. If the user is unsure of their login credentials, reset their password and provide them with the new login information."
  destination_path = "/agent/scripts/reset_postgres_password.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_check_pg_service" {
  name        = "invoke_check_pg_service"
  description = "Next Step"
  command     = "`chmod +x /agent/scripts/check_pg_service.sh && /agent/scripts/check_pg_service.sh`"
  params      = []
  file_deps   = ["check_pg_service"]
  enabled     = true
  depends_on  = [shoreline_file.check_pg_service]
}

resource "shoreline_action" "invoke_db_config_check" {
  name        = "invoke_db_config_check"
  description = "The database configuration settings have been changed or misconfigured, leading to authentication issues."
  command     = "`chmod +x /agent/scripts/db_config_check.sh && /agent/scripts/db_config_check.sh`"
  params      = ["PATH_TO_DATABASE_CONFIGURATION_FILE"]
  file_deps   = ["db_config_check"]
  enabled     = true
  depends_on  = [shoreline_file.db_config_check]
}

resource "shoreline_action" "invoke_reset_postgres_password" {
  name        = "invoke_reset_postgres_password"
  description = "Verify that the user is entering the correct login credentials. If the user is unsure of their login credentials, reset their password and provide them with the new login information."
  command     = "`chmod +x /agent/scripts/reset_postgres_password.sh && /agent/scripts/reset_postgres_password.sh`"
  params      = ["NEW_PASSWORD","POSTGRES_USER"]
  file_deps   = ["reset_postgres_password"]
  enabled     = true
  depends_on  = [shoreline_file.reset_postgres_password]
}

