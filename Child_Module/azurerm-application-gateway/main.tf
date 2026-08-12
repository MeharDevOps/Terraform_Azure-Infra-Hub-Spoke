
data "azurerm_public_ip" "pip" {
  for_each = var.application_gateways
  name                = each.value.pip_name
  resource_group_name = each.value.rg_name
}

#################################
# NIC Data Source
#################################
data "azurerm_network_interface" "nic" {
  for_each = var.network_nic
  name                = each.value.nic_name
  resource_group_name = each.value.rg_name
}

data "azurerm_subnet" "subnet" {
  for_each             = var.application_gateways
  name                 = each.value.subnet_name
  virtual_network_name = each.value.vnet_name
  resource_group_name  = each.value.rg_name
}

resource "azurerm_application_gateway" "Appgate" {
  for_each = var.application_gateways
  name                = each.value.name
  resource_group_name = each.value.rg_name
  location            = each.value.location
  sku {
    name     = each.value.sku.name
    tier     = each.value.sku.tier
    capacity = each.value.sku.capacity
  }
  gateway_ip_configuration {
    name      = each.value.gateway_ip_configuration.name
    subnet_id = data.azurerm_subnet.subnet[each.key].id
  }
  dynamic "frontend_port" {
    for_each = each.value.frontend_ports
    content {
      name = frontend_port.value.name
      port = frontend_port.value.port
    }
  }

  dynamic "frontend_ip_configuration" {
    for_each = each.value.frontend_ip_configurations
    content {
      name                 = frontend_ip_configuration.value.name
      public_ip_address_id = data.azurerm_public_ip.pip[each.key].id
    }
  }
  dynamic "backend_address_pool" {
    for_each = each.value.backend_address_pools
    content {
      name = backend_address_pool.value.name
    }
  }

  dynamic "backend_http_settings" {
    for_each = each.value.backend_http_settings
    content {
      name                  = backend_http_settings.value.name
      cookie_based_affinity = backend_http_settings.value.cookie_based_affinity
      path                  = backend_http_settings.value.path
      port                  = backend_http_settings.value.port
      protocol              = backend_http_settings.value.protocol
      request_timeout       = backend_http_settings.value.request_timeout
    }
  }

  dynamic "http_listener" {
    for_each = each.value.http_listeners
    content {
      name                           = http_listener.value.name
      frontend_ip_configuration_name = http_listener.value.ip_config_name
      frontend_port_name             = http_listener.value.frontend_port_name
      protocol                       = http_listener.value.protocol
    }
  }

  dynamic "request_routing_rule" {
    for_each = each.value.request_routing_rules
    content {
      name                       = request_routing_rule.value.name
      priority                   = request_routing_rule.value.priority
      rule_type                  = request_routing_rule.value.rule_type
      http_listener_name         = request_routing_rule.value.http_listener_name
      backend_address_pool_name  = request_routing_rule.value.backend_address_pool_name
      backend_http_settings_name = request_routing_rule.value.backend_http_settings_name
    }
  }
}


locals {
  vm_backends = merge([
    for agw_key, agw in var.application_gateways : {
      for vm_key, vm in agw.vm_backend_association : "${agw_key}-${vm_key}" => merge(vm, {
        agw_key = agw_key
        nic_key = one([for k, n in var.network_nic : k if n.nic_name == vm.nic_name])
      })
    }
  ]...)
}

resource "azurerm_network_interface_application_gateway_backend_address_pool_association" "vm_backend" {
  for_each = local.vm_backends

  network_interface_id  = data.azurerm_network_interface.nic[each.value.nic_key].id
  ip_configuration_name = each.value.ip_config_name

  backend_address_pool_id = one([
    for p in azurerm_application_gateway.Appgate[each.value.agw_key].backend_address_pool :
    p.id if p.name == each.value.backend_pool_name
  ])
}
