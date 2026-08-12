resource "azurerm_public_ip" "pip" {
  for_each = var.public_ip

  name                = each.value.pip_name
  resource_group_name = each.value.rg_name
  location            = each.value.location
  allocation_method   = each.value.allocation_method

  #  Optional Attributes
  sku                         = lookup(each.value, "sku", "Standard")  # Basic or Standard
  idle_timeout_in_minutes      = lookup(each.value, "idle_timeout_in_minutes", 4)
  domain_name_label            = lookup(each.value, "domain_name_label", null)
  ip_version                   = lookup(each.value, "ip_version", "IPv4")        # IPv4 / IPv6
  zones                        = lookup(each.value, "zones", null)               # ["1"], ["1","2","3"]
  ddos_protection_mode         = lookup(each.value, "ddos_protection_mode", null)
  ddos_protection_plan_id      = lookup(each.value, "ddos_protection_plan_id", null)
  reverse_fqdn                 = lookup(each.value, "reverse_fqdn", null)

  tags = lookup(each.value, "tags", {
    environment = "dev"
    owner       = "mehar"
  })
}

