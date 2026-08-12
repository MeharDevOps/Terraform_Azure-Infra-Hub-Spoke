
variable "network_nsg" {
  description = "Map of Network Security Groups and their rules"
  type = map(object({
    nsg_name   = string
    location   = string
    rg_name    = string
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



variable "network_nic" {
  description = "Map of NIC configurations and NSG mapping"
  type = map(object({
    nic_name        = string
    location        = string
    rg_name         = string
    ip_config_name  = string
    private_ip_meth = string
    subnet_name     = string
    vnet_name       = string
    nsg_key         = optional(string, "nsg1")
  }))
}