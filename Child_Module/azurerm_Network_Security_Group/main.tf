resource "azurerm_network_security_group" "nsg" {
  for_each = var.network_nsg

  name                = each.value.nsg_name
  location            = each.value.location
  resource_group_name = each.value.rg_name
  # Add NSG rules dynamically
  dynamic "security_rule" {
    for_each = lookup(each.value, "rules", [])
    content {
      name                       = security_rule.value.rule_name
      priority                   = security_rule.value.priority
      direction                   = security_rule.value.direction
      access                      = security_rule.value.access
      protocol                    = security_rule.value.protocol
      source_port_range           = security_rule.value.source_port_range
      destination_port_range      = security_rule.value.destination_port_range
      source_address_prefix       = security_rule.value.source_address_prefix
      destination_address_prefix  = security_rule.value.destination_address_prefix
    }
  }

  tags = lookup(each.value, "tags", null)
}



#################################
# NIC Data Source
#################################
data "azurerm_network_interface" "nic" {
  for_each = var.network_nic
  name                = each.value.nic_name
  resource_group_name = each.value.rg_name
}

#################################
# NSG Association with NIC
#################################
resource "azurerm_network_interface_security_group_association" "nic_assoc" {
  for_each = {
    for k, v in var.network_nic : k => v
    if lookup(v, "nsg_key", null) != null && contains(keys(azurerm_network_security_group.nsg), lookup(v, "nsg_key", ""))
  }
  network_interface_id      = data.azurerm_network_interface.nic[each.key].id
  network_security_group_id = azurerm_network_security_group.nsg[each.value.nsg_key].id
}



