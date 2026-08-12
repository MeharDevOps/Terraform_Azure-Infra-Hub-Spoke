data "azurerm_client_config" "current" {}

# Assume Key Vault already exists
data "azurerm_key_vault" "kv" {
  for_each            = var.secret
  name                = each.value.keyvault_name # existing KV name
  resource_group_name = each.value.rg_name
}

# Generate random VM username
resource "random_string" "vm_username" {
  for_each = var.secret
  length   = each.value.length
  lower    = each.value.lower
  upper    = each.value.upper
  special  = each.value.special
}

# Generate random VM password
resource "random_password" "vm_password" {
    for_each = var.secret
  length           = each.value.length
  special          = each.value.special
  override_special = each.value.override_special
}


# Create username secret
resource "azurerm_key_vault_secret" "vm_username_secret" {
  for_each    = { for k,v in var.secret : k => v if k == "username" }
  name        = each.value.secret_name
  value       = random_string.vm_username[each.key].result
  key_vault_id = data.azurerm_key_vault.kv[each.key].id
}

# Create password secret
resource "azurerm_key_vault_secret" "vm_password_secret" {
  for_each    = { for k,v in var.secret : k => v if k == "password" }
  name        = each.value.secret_name
  value       = random_password.vm_password[each.key].result
  key_vault_id = data.azurerm_key_vault.kv[each.key].id
}


# Output username secrets
output "username_secret" {
  value = {
    for k, v in azurerm_key_vault_secret.vm_username_secret :
    k => v.value
  }
}

# Output password secrets
output "password_secret" {
  value = {
    for k, v in azurerm_key_vault_secret.vm_password_secret :
    k => v.value
  }
}