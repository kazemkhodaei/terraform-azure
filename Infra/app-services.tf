resource "azurerm_app_service" "weater_app_service" {
  name                = "kz-weather-app-service"
  location            = azurerm_resource_group.terraformResource.location
  resource_group_name = azurerm_resource_group.terraformResource.name
  app_service_plan_id = azurerm_service_plan.weather.id
  identity {
    type = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.weather_user_assigned_identity.id]
  }

  app_settings = {
    "ApplicationInsights__ConnectionString" = azurerm_application_insights.kazem_application_insight.connection_string
    "AzureAd__UserAssigendClientId"         = azurerm_user_assigned_identity.weather_user_assigned_identity.client_id
  }
  depends_on = [azurerm_service_plan.weather, azurerm_application_insights.kazem_application_insight]

  connection_string {
    name  = "AzureStorageAccount"
    type  = "Custom"
    value = azurerm_storage_account.storage_account.primary_connection_string
  }

  connection_string {
    name  = "SqlDatabase"
    type  = "SQLServer"
    value = "Server=tcp:${azurerm_mssql_server.sqlServer.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.weather_database.name};Persist Security Info=False;MultipleActiveResultSets=False;Encrypt=False;TrustServerCertificate=False;Connection Timeout=30;"
  }

}

//CREATE USER [weather-manage-identity] FROM EXTERNAL PROVIDER;

//ALTER ROLE db_owner ADD MEMBER [weather-manage-identity];

# use local tf file for tag  
# https://developer.hashicorp.com/terraform/language/values/locals 
# https://github.com/TheSustainables/patterns-and-practices/tree/main/practices/naming-conventions/metrics-and-tags 
#https://github.com/TheSustainables/patterns-and-practices/blob/main/patterns/infrastructure-as-code/identity.md 
# use app configuration for business configuration