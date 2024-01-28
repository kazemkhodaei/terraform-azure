provider "azurerm" {
  features {

  }
}

resource "azurerm_resource_group" "terraformResource" {
  name     = var.resource_group_name
  location = "west europe"
}

resource "azurerm_storage_account" "storage_account" {
  name                     = "kzmainstorageaccount"
  resource_group_name      = var.resource_group_name
  location                 = azurerm_resource_group.terraformResource.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

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
  name      = "weatherDatabase"
  server_id = azurerm_mssql_server.sqlServer.id
  sku_name = "Basic"
  license_type   = "LicenseIncluded"
  max_size_gb    = 1
  geo_backup_enabled = "false"

  tags = {
    environment = "test"
  }
}

resource "azurerm_application_insights" "kazem_application_insight" {
  application_type = "web"
  resource_group_name = var.resource_group_name
  name = "kazem-application-insight"
  location = azurerm_resource_group.terraformResource.location
  workspace_id = azurerm_log_analytics_workspace.kazem_application_workspace.id

}

resource "azurerm_log_analytics_workspace" "kazem_application_workspace" {
  name                = "workspace-kazem"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  sku                 = "Free"
}



resource "azurerm_service_plan" "weather" {
  name                = "weather-appserviceplan"
  location            = azurerm_resource_group.terraformResource.location
  resource_group_name = azurerm_resource_group.terraformResource.name
  sku_name            = "B1"
  os_type             = "Windows"
}

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
    value = "Server=tcp:${azurerm_mssql_server.sqlServer.fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.weather_database.name};Persist Security Info=False;User ID=${azurerm_mssql_server.sqlServer.administrator_login};Password=${azurerm_mssql_server.sqlServer.administrator_login_password};MultipleActiveResultSets=False;Encrypt=False;TrustServerCertificate=False;Connection Timeout=30;"
  }
  
}

resource "azurerm_virtual_network" "weather_vnet" {
  name                = "weather_vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.terraformResource.location
  resource_group_name = var.resource_group_name
}



# resource "azurerm_mssql_firewall_rule" "database_firewall" {
#   for_each =  toset(azurerm_app_service.weater_app_service.possible_outbound_ip_address_list)
#   name             = "weatherAccessToDatabase${each.value}"
#   server_id        = azurerm_mssql_server.sqlServer.id
#   start_ip_address = each.value
#   end_ip_address   = each.value
#   depends_on = [ azurerm_mssql_server.sqlServer ]
# }

resource "azurerm_subnet" "weather_subnet" {
  name                 = "weather_subnet"
  resource_group_name  = azurerm_resource_group.terraformResource.name
  virtual_network_name = azurerm_virtual_network.weather_vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.Sql"]

  delegation {
    name = "delegation"
    service_delegation {
      name    = "Microsoft.Web/serverFarms"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}


resource "azurerm_app_service_virtual_network_swift_connection" "weather_swift_connection" {
  app_service_id = azurerm_app_service.weater_app_service.id
  subnet_id      = azurerm_subnet.weather_subnet.id
}

resource "azurerm_sql_virtual_network_rule" "weather_sql_vnet_rule" {
  name                = "weather_sql_vnet_rule"
  resource_group_name = azurerm_resource_group.terraformResource.name
  server_name         = azurerm_mssql_server.sqlServer.name
  subnet_id           = azurerm_subnet.weather_subnet.id
}

output "storage_account_connection_string" {
  value     = azurerm_storage_account.storage_account.primary_connection_string
  sensitive = true
}
