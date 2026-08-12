variable "resource_group" {
  type = map(object({
    rg_name    = string
    location   = string
    managed_by = optional(string)
    tags       = optional(map(string))
  }))
}

variable "virtual_network" {
  type = map(object({
    vnet_name               = string
    rg_name                 = string
    location                = string
    address_space           = list(string)
    dns_servers             = optional(list(string))
    edge_zone               = optional(string)
    bgp_community           = optional(string)
    flow_timeout_in_minutes = optional(number)
    tags                    = optional(map(string))
  }))
}

variable "vnet_peerings" {
  type = map(object({
    name                        = string
    local_vnet                  = string
    remote_vnet                 = string
    allow_virtual_network_access = optional(bool)
    allow_forwarded_traffic      = optional(bool)
    allow_gateway_transit        = optional(bool)
    use_remote_gateways          = optional(bool)
  }))
  default = {}
}


variable "subnet" {
  type = map(object({
    subnet_name                           = string
    vnet_name                             = string
    rg_name                               = string
    address_prefixes                      = list(string)
    service_endpoints                     = optional(list(string))
    private_endpoint_network_policies     = optional(string)
    private_link_service_network_policies = optional(string)
    delegation = optional(list(object({
      name = string
      service_delegation = object({
        name    = string
        actions = list(string)
      })
    })))
  }))
}


variable "public_ip" {
  type = map(object({
    pip_name                = string
    rg_name                 = string
    location                = string
    allocation_method       = string
    sku                     = optional(string)
    idle_timeout_in_minutes = optional(number)
    domain_name_label       = optional(string)
    ip_version              = optional(string)
    zones                   = optional(list(string))
    ddos_protection_mode    = optional(string)
    ddos_protection_plan_id = optional(string)
    reverse_fqdn            = optional(string)
    tags                    = optional(map(string))
  }))
}




variable "azure_bastion" {
  description = "Bastion setup configuration"
  type = map(object({
    bastion_name       = string
    location           = string
    rg_name            = string
    vnet_name          = string
    bastion_subnetname = string
    address_prefixes   = list(string)
    pip_name           = string
    tags               = optional(map(string))
  }))
}


variable "firewall" {
  type = map(object({
    firewall_name     = string
    rg_name           = string
    location          = string
    sku_name          = string
    sku_tier          = string
    pip_name          = optional(string)
    vnet_name         = optional(string)
    subnet_name       = optional(string)

    firewall_policy_id = optional(string)

    dns_servers       = optional(list(string))
    dns_proxy_enabled = optional(bool)
    private_ip_ranges = optional(list(string))
    threat_intel_mode = optional(string)
    zones             = optional(list(string))
    tags              = optional(map(string))

    ip_configuration = optional(list(object({
      name                 = string
      subnet_id            = optional(string)
      public_ip_address_id = optional(string)
    })))

    management_ip_configuration = optional(list(object({
      mic_name                 = string
      subnet_id            = string
      public_ip_address_id = string
    })))

    virtual_hub = optional(list(object({
      virtual_hub_id = string
      public_ip_count = optional(number)
    })))
  }))
}

