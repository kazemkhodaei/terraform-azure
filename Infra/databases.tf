data "azurerm_subscription" "primary" {
}

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


resource "azurerm_role_assignment" "weather_user_assigned_identity_sql_db_contributor" {
  principal_id   = azurerm_user_assigned_identity.weather_user_assigned_identity.client_id
  role_definition_name = "SQL DB Contributor"
  scope          = azurerm_mssql_server.sqlServer.id
}


resource "null_resource" "database" { 
  provisioner "local-exec" { 
    command = <<eot
    Set-AzContext -SubscriptionId "d540cb03-fbc9-4071-b901-daa963e21ea2"
    $token = (Get-AzAccessToken -ResourceUrl https://database.windows.net).Token 
$query= 'CREATE USER [${azurerm_user_assigned_identity.weather_user_assigned_identity.name}] FOR EXTERNAL PROVIDER;'
Invoke-SqlCmd -ServerInstance ${azurerm_mssql_server.sqlServer.fully_qualified_domain_name} -Database ${azurerm_mssql_server.sqlServer.name} -AccessToken $token -Query $query 
     eot
    interpreter = ["PowerShell", "-Command"] 
  } 
  depends_on = [ 
    azurerm_mssql_database.weather_database 
  ] 
}
