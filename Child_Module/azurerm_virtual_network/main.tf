resource "azurerm_virtual_network" "vnet" {
  for_each            = var.virtual_network
  name                = each.value.vnet_name
  resource_group_name = each.value.rg_name
  location            = each.value.location
  address_space       = each.value.address_space

  # Optional attributes
  dns_servers           = lookup(each.value, "dns_servers", null)
  edge_zone             = lookup(each.value, "edge_zone", null)
  bgp_community         = lookup(each.value, "bgp_community", null)
  flow_timeout_in_minutes = lookup(each.value, "flow_timeout_in_minutes", null)

  tags = lookup(each.value, "tags", {
    environment = "dev"
    owner       = "mehar"
  })
}
