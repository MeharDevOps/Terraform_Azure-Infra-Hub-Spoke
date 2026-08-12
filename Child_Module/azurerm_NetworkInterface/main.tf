#  Data block to fetch subnet ID dynamically
data "azurerm_subnet" "subnet" {
  for_each             = var.network_nic
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.rg_name
}

#  NIC Resource
resource "azurerm_network_interface" "nic" {
  for_each = var.network_nic

  name                          = each.value.nic_name
  location                      = each.value.location
  resource_group_name           = each.value.rg_name
  dns_servers                   = lookup(each.value, "dns_servers", [])
  accelerated_networking_enabled = lookup(each.value, "enable_accelerated_networking", false)
  ip_forwarding_enabled          = lookup(each.value, "enable_ip_forwarding", false)
  ip_configuration {
    name                          = each.value.ip_config_name
    subnet_id                     = data.azurerm_subnet.subnet[each.key].id
    private_ip_address_allocation = each.value.private_ip_meth
    private_ip_address_version    = lookup(each.value, "private_ip_address_version", "IPv4")
    private_ip_address            = lookup(each.value, "private_ip_address", null)    
    public_ip_address_id          = lookup(each.value, "public_ip_address_id", null)
    primary                       = lookup(each.value, "primary", true)
  }

  tags = lookup(each.value, "tags", {
    environment = "dev"
    owner       = "mehar"
  })
}
