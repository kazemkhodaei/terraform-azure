

resource "azurerm_key_vault" "mainKeyVault" {
  name                        = "mainlekeyvault"
  location                    = azurerm_resource_group.terraformResource.location
  resource_group_name         = azurerm_resource_group.terraformResource.name
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false

  sku_name = "standard"

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

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
  
  lifecycle {
    prevent_destroy = true
  }
}