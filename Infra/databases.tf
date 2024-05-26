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



resource "azurerm_mssql_active_directory_administrator" "githubPrincipal" {
  server_name         = azurerm_mssql_server.example.name
  resource_group_name = azurerm_resource_group.example.name
  login               = "github service principal"  # GitHub principal display name
  object_id           = "e5da7f7c-f378-4dc3-9959-878678d3bf41"     # GitHub principal Object ID
  tenant_id           = "a45661e0-d859-4a2c-9e22-99793b6060e6"                      # Tenant ID
}





resource "null_resource" "database" { 
  provisioner "local-exec" { 
    command = <<eot
    Set-AzContext -SubscriptionId "d540cb03-fbc9-4071-b901-daa963e21ea2"
    $token = (Get-AzAccessToken -ResourceUrl https://database.windows.net).Token 

    $query= @' 
CREATE USER [${azurerm_user_assigned_identity.weather_user_assigned_identity.name}] FOR EXTERNAL PROVIDER; 
GO 
ALTER ROLE [db_owner] ADD MEMBER [${azurerm_user_assigned_identity.weather_user_assigned_identity.name}]; 
GO 
'@ 
Invoke-SqlCmd -ServerInstance ${azurerm_mssql_server.sqlServer.fully_qualified_domain_name} -Database ${azurerm_mssql_server.sqlServer.name} -AccessToken $token -Query $query 
     eot
    interpreter = ["PowerShell", "-Command"] 
  } 
  depends_on = [ 
    azurerm_mssql_database.weather_database 
  ] 
}
