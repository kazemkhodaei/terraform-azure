resource "azurerm_virtual_network" "weather_vnet" {
  name                = "weather_vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.terraformResource.location
  resource_group_name = var.resource_group_name
}


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

## enable private endpoint and disable public access for SqL server 
## add vpn to access to subnet https://learn.microsoft.com/en-us/azure/vpn-gateway/point-to-site-about