resource "azurerm_app_service" "weater_app_service" {
  name                = "kz-weather-app-service"
  location            = azurerm_resource_group.terraformResource.location
  resource_group_name = azurerm_resource_group.terraformResource.name
  app_service_plan_id = azurerm_service_plan.weather.id

  app_settings = {
    "ApplicationInsights__ConnectionString" = azurerm_application_insights.kazem_application_insight.connection_string
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
    value = azurerm_mssql_database.weather_database.primary_connection_string
  }

}