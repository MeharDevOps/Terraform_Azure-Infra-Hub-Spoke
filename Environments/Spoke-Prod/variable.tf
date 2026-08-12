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

variable "network_nic" {
  type = map(object({
    nic_name                      = string
    location                      = string
    rg_name                       = string
    ip_config_name                = string
    private_ip_meth               = string
    subnet_name                   = string
    vnet_name                     = string
    nsg_key                       = optional(string)
    enable_accelerated_networking = optional(bool)
    enable_ip_forwarding          = optional(bool)
    dns_servers                   = optional(list(string))
    private_ip_address            = optional(string)
    private_ip_address_version    = optional(string)
    public_ip_address_id          = optional(string)
    primary                       = optional(bool)
    tags                          = optional(map(string))
  }))
}

variable "vmss" {
  description = "Map of Linux Virtual Machine Scale Sets"
  type = map(object({
    vmss_name            = string
    rg_name              = string
    location             = string
    sku                  = string
    instances            = number
    keyvault_name        = optional(string)
    username_secret_name = optional(string, "vm-admin-username")
    password_secret_name = optional(string, "vm-admin-password")
    subnet_name          = string
    vnet_name            = string
    backend_pool_id      = optional(string)
    tags                 = optional(map(string))
  }))
}



variable "network_nsg" {
  description = "Map of Network Security Groups and their rules"
  type = map(object({
    nsg_name = string
    location = string
    rg_name  = string
    rules = optional(list(object({
      rule_name                  = string
      priority                   = number
      direction                  = string
      access                     = string
      protocol                   = string
      source_port_range          = string
      destination_port_range     = string
      source_address_prefix      = string
      destination_address_prefix = string
    })), [])
    tags = optional(map(string))
  }))
}



variable "keyvaults" {
  description = "Map of Key Vault configurations"
  type = map(object({
    keyvault_name              = string
    location                   = string
    rg_name                    = string
    sku_name                   = optional(string)
    soft_delete_retention_days = optional(number)
    key_permissions            = optional(list(string))
    secret_permissions         = optional(list(string))
    tags                       = optional(map(string))
  }))
}

variable "secret" {
  description = "Map of secrets to generate and store in existing Key Vault"
  type = map(object({
    keyvault_name    = string
    rg_name          = string
    secret_name      = string
    length           = number
    lower            = optional(bool, true)
    upper            = optional(bool, true)
    special          = optional(bool, false)
    override_special = optional(string)
  }))
}
