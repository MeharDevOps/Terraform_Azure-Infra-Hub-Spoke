
data "azurerm_public_ip" "pip" {
  for_each = var.azure_bastion
  name                = each.value.pip_name
  resource_group_name = each.value.rg_name
}

resource "azurerm_subnet" "bastion_subnet" {
  for_each = var.azure_bastion
  name                 = each.value.bastion_subnetname   # must be AzureBastionSubnet
  resource_group_name  = each.value.rg_name
  virtual_network_name = each.value.vnet_name
  address_prefixes     = each.value.address_prefixes
}

resource "azurerm_bastion_host" "bastion" {
  for_each = var.azure_bastion
  name                = each.value.bastion_name
  location            = each.value.location
  resource_group_name = each.value.rg_name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion_subnet[each.key].id
    public_ip_address_id = data.azurerm_public_ip.pip[each.key].id
  }

  tags = lookup(each.value, "tags", null)
}



