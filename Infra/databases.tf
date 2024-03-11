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

resource "mssql_user" "example" {
  server {
    host = azurerm_mssql_server.sqlServer.fully_qualified_domain_name
    azuread_managed_identity_auth  {
     user_id = azurerm_user_assigned_identity.weather_user_assigned_identity.id
    }
  }

  database  = azurerm_mssql_database.weather_database.name
  username  = azurerm_user_assigned_identity.weather_user_assigned_identity.name
  object_id = azurerm_user_assigned_identity.weather_user_assigned_identity.client_id

  roles     = ["db_owner"]
  depends_on = [azurerm_mssql_database.weather_database]
}

