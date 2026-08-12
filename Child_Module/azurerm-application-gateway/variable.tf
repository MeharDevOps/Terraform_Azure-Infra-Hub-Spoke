variable "application_gateways" {
  description = "Application Gateway configuration"
  type = map(object({
    name        = string
    rg_name     = string
    location    = string
    pip_name    = string
    subnet_name = string
    vnet_name   = string

    sku = object({
      name     = string
      tier     = string
      capacity = number
    })

    gateway_ip_configuration = object({
      name = string
    })

    frontend_ports = map(object({
      name = string
      port = number
    }))

    frontend_ip_configurations = map(object({
      name = string
    }))

    backend_address_pools = map(object({
      name = string
    }))

    backend_http_settings = map(object({
      name                  = string
      cookie_based_affinity = string
      path                  = string
      port                  = number
      protocol              = string
      request_timeout       = number
    }))

    http_listeners = map(object({
      name                           = string
      ip_config_name = string
      frontend_port_name             = string
      protocol                       = string
    }))

    request_routing_rules = map(object({
      name                       = string
      priority                   = number
      rule_type                  = string
      http_listener_name         = string
      backend_address_pool_name  = string
      backend_http_settings_name = string
    }))

    vm_backend_association = optional(map(object({
      backend_pool_name    = string
      ip_config_name       = string
      nic_name             = string
      rg_name              = string
      username_secret_name = optional(string)
      password_secret_name = optional(string)
    })), {})
  }))
}


variable "network_nic" {
  type = map(object({
    nic_name        = string
    location        = string
    rg_name         = string
    ip_config_name  = string
    private_ip_meth = string
    subnet_name     = string
    vnet_name       = string
    # enable_accelerated_networking = optional(bool)
    # enable_ip_forwarding          = optional(bool)
    dns_servers                = optional(list(string))
    private_ip_address         = optional(string)
    private_ip_address_version = optional(string)
    public_ip_address_id       = optional(string)
    primary                    = optional(bool)
    tags                       = optional(map(string))
  }))
}


