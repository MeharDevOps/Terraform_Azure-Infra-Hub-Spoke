data "azurerm_subnet" "subnet" {
  for_each             = var.vmss
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.rg_name
}

# Fetch Key Vault data source if keyvault_name is provided
data "azurerm_key_vault" "kv" {
  for_each            = { for k, v in var.vmss : k => v if lookup(v, "keyvault_name", null) != null }
  name                = each.value.keyvault_name
  resource_group_name = each.value.rg_name
}

# Fetch Admin Username secret from Key Vault
data "azurerm_key_vault_secret" "vm_username" {
  for_each     = { for k, v in var.vmss : k => v if lookup(v, "keyvault_name", null) != null }
  name         = each.value.username_secret_name
  key_vault_id = data.azurerm_key_vault.kv[each.key].id
}

# Fetch Admin Password secret from Key Vault
data "azurerm_key_vault_secret" "vm_password" {
  for_each     = { for k, v in var.vmss : k => v if lookup(v, "keyvault_name", null) != null }
  name         = each.value.password_secret_name
  key_vault_id = data.azurerm_key_vault.kv[each.key].id
}

resource "azurerm_linux_virtual_machine_scale_set" "vmss" {
  for_each                        = var.vmss
  name                            = each.value.vmss_name
  resource_group_name             = each.value.rg_name
  location                        = each.value.location
  sku                             = each.value.sku
  instances                       = each.value.instances
  admin_username                  = data.azurerm_key_vault_secret.vm_username[each.key].value
  admin_password                  = data.azurerm_key_vault_secret.vm_password[each.key].value
  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  network_interface {
    name    = "${each.value.vmss_name}-nic"
    primary = true

    ip_configuration {
      name                                          = "internal"
      primary                                       = true
      subnet_id                                     = data.azurerm_subnet.subnet[each.key].id
      application_gateway_backend_address_pool_ids = each.value.backend_pool_id != null ? [each.value.backend_pool_id] : null
    }
  }

  tags = lookup(each.value, "tags", {
    environment = "dev"
    owner       = "mehar"
  })
}