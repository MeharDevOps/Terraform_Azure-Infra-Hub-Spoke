data "azurerm_public_ip" "pip" {
  for_each            = { for k, v in var.firewall : k => v if v.pip_name != null }
  name                = each.value.pip_name
  resource_group_name = each.value.rg_name
}

data "azurerm_subnet" "subnet" {
  for_each             = { for k, v in var.firewall : k => v if v.subnet_name != null && v.vnet_name != null }
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.rg_name
}

resource "azurerm_firewall" "firewall" {
  for_each = var.firewall

  name                = each.value.firewall_name
  resource_group_name = each.value.rg_name
  location            = each.value.location

  sku_name = each.value.sku_name
  sku_tier = each.value.sku_tier

  firewall_policy_id = lookup(each.value, "firewall_policy_id", null)
  dns_servers        = lookup(each.value, "dns_servers", null)
  dns_proxy_enabled  = lookup(each.value, "dns_proxy_enabled", null)
  private_ip_ranges  = lookup(each.value, "private_ip_ranges", null)
  threat_intel_mode  = lookup(each.value, "threat_intel_mode", "Alert")
  zones              = lookup(each.value, "zones", null)
  tags               = lookup(each.value, "tags", null)

  dynamic "ip_configuration" {
    for_each = each.value.ip_configuration != null ? each.value.ip_configuration : (
      each.value.pip_name != null ? [
        {
          name                 = "firewall-ip-config"
          subnet_id            = null
          public_ip_address_id = null
        }
      ] : []
    )

    content {
      name                 = try(ip_configuration.value.name, "firewall-ip-config")
      subnet_id            = coalesce(lookup(ip_configuration.value, "subnet_id", null), try(data.azurerm_subnet.subnet[each.key].id, null))
      public_ip_address_id = coalesce(lookup(ip_configuration.value, "public_ip_address_id", null), try(data.azurerm_public_ip.pip[each.key].id, null))
    }
  }

  dynamic "management_ip_configuration" {
    for_each = each.value.management_ip_configuration != null ? each.value.management_ip_configuration : []

    content {
      name                 = management_ip_configuration.value.mic_name
      subnet_id            = management_ip_configuration.value.subnet_id
      public_ip_address_id = management_ip_configuration.value.public_ip_address_id
    }
  }

  dynamic "virtual_hub" {
    for_each = each.value.virtual_hub != null ? each.value.virtual_hub : []

    content {
      virtual_hub_id  = virtual_hub.value.virtual_hub_id
      public_ip_count = lookup(virtual_hub.value, "public_ip_count", 1)
    }
  }
}