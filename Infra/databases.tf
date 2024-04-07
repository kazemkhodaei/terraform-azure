resource "azurerm_mssql_server" "sqlServer" {
  name                         = "kazem-sql-server"
  version                      = "12.0"
  location                     = azurerm_resource_group.terraformResource.location
  administrator_login          = "kazemAdmin"
  administrator_login_password = "5GBDT%6eqq2te"
  resource_group_name          = var.resource_group_name
}


resource "azurerm_mssql_database" "weather_database" {
  name               = "weatherDatabase"
  server_id          = azurerm_mssql_server.sqlServer.id
  sku_name           = "Basic"
  license_type       = "LicenseIncluded"
  max_size_gb        = 1
  geo_backup_enabled = "false"

  tags = {
    environment = "test"
  }
}

# resource "mssql_user" "example" {
#   server {
#     host = azurerm_mssql_server.sqlServer.fully_qualified_domain_name
#     azuread_managed_identity_auth  {
#       user_id = azurerm_user_assigned_identity.weather_user_assigned_identity.id
#     }
#   }

#   database  = azurerm_mssql_database.weather_database.name
#   username  = azurerm_user_assigned_identity.weather_user_assigned_identity.name
#   object_id = azurerm_user_assigned_identity.weather_user_assigned_identity.client_id

#   roles     = ["db_owner"]
#   depends_on = [azurerm_mssql_database.weather_database]
# }


# resource "azurerm_sql_active_directory_administrator" "AddAdminitstrator" {
#   server_name         = azurerm_sql_server.sqlServer.name
#   resource_group_name = var.resource_group_name
#   login               = "AzureADAdmin"
#   tenant_id           = "a45661e0-d859-4a2c-9e22-99793b6060e6"
#   object_id           = "your-aad-admin-object-id" # Azure AD user or group object ID
# }

## set  azuread_authentication_only instead of using username and password  
## https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server
## lets discuss which on is better one, run manually or mssql_user  
## figure out how it is safe