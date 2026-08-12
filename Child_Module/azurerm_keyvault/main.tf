data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "keyvault" {
  for_each = var.keyvaults
  name                       = each.value.keyvault_name
  location                   = each.value.location
  resource_group_name        = each.value.rg_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = lookup(each.value, "sku_name", "standard")
  soft_delete_retention_days = lookup(each.value, "soft_delete_retention_days", 30)

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id
    key_permissions    = lookup(each.value, "key_permissions", ["Create", "List", "Get"])
    secret_permissions = lookup(each.value, "secret_permissions", ["Set", "Get", "Delete", "List", "Purge", "Recover"])
  }

  tags = lookup(each.value, "tags", null)
}

