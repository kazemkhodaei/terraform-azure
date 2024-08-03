data "azurerm_client_config" "current" {}

data "azurerm_key_vault_secret" "sql_admin_login" {
  name         = "sql-admin-login"
  key_vault_id = data.azurerm_key_vault.mainKeyVault.id
}

data "azurerm_key_vault_secret" "sql_admin_password" {
  name         = "sql-admin-password"
  key_vault_id = data.azurerm_key_vault.mainKeyVault.id
}