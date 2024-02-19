resource "azurerm_user_assigned_identity" "weather_user_assigned_identity" {
  location            = azurerm_resource_group.terraformResource.location
  name                = "weather-manage-identity"
  resource_group_name = var.resource_group_name
}