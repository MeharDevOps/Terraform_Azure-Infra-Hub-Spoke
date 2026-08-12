resource "azurerm_virtual_network_peering" "peering" {
  for_each = var.vnet_peerings
  name                      = each.value.name
  resource_group_name       = var.vnet_rg_names[each.value.local_vnet]
  virtual_network_name      = var.vnet_names[each.value.local_vnet]
  remote_virtual_network_id = var.vnet_ids[each.value.remote_vnet]
  allow_virtual_network_access = lookup(each.value, "allow_virtual_network_access", true)
  allow_forwarded_traffic      = lookup(each.value, "allow_forwarded_traffic", true)
  allow_gateway_transit        = lookup(each.value, "allow_gateway_transit", false)
  use_remote_gateways          = lookup(each.value, "use_remote_gateways", false)
}
