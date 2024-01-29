resource "azurerm_key_vault" "weathe-keyvault" {
  name                = "weather-kv"
  location            = terraformResource.location
  resource_group_name = var.resource_group_name
  tenant_id           = azurerm_app_service.weater_app_service.id
  sku_name            = "standard"
  access_policy = {
    tenant_id = azurerm_app_service.weater_app_service.id
    object_id = azurerm_app_service.weater_app_service.object_id

    key_permissions = [
      "Get",
    ]

    secret_permissions = [
      "Get",
    ]

    storage_permissions = [
      "Get",
    ]
  }

}


