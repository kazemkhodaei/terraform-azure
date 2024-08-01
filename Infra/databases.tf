data "azurerm_subscription" "primary" {
}

resource "azurerm_mssql_server" "sqlServer" {
  name                         = "kazem-sql-server"
  version                      = "12.0"
  location                     = azurerm_resource_group.terraformResource.location
  administrator_login          = "kazemAdmin"
  administrator_login_password = "5GBDT%6eqq2te"
  resource_group_name          = var.resource_group_name
   azuread_administrator {
    login_username = "github service principal"
    object_id      = "600f8320-c7f9-4059-a238-ff23083b24d1"
  }
}


# resource "azurerm_sql_firewall_rule" "example" {
#   name                = "FirewallRule1"
#   resource_group_name = var.resource_group_name
#   server_name         = azurerm_mssql_server.sqlServer.name
#   start_ip_address    = "31.201.26.114"
#   end_ip_address      = "31.201.26.114"
# }


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


resource "null_resource" "database" { 
  provisioner "local-exec" { 
    command = <<eot
      $token = az account get-access-token --resource https://database.windows.net --query accessToken -o tsv
      $query= 'CREATE USER [${azurerm_user_assigned_identity.weather_user_assigned_identity.name}] FOR EXTERNAL PROVIERD; ' 
      Invoke-SqlCmd -ServerInstance ${azurerm_mssql_server.sqlServer.fully_qualified_domain_name} -Database ${azurerm_mssql_database.weather_database.name} -AccessToken $token -Query $query 
     eot
    interpreter = ["PowerShell", "-Command"] 
  } 
  depends_on = [ 
    azurerm_mssql_database.weather_database 
  ] 
}
