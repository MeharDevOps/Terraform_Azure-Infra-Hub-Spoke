
variable "network_nic" {
  type = map(object({
    nic_name                      = string
    location                      = string
    rg_name                       = string
    ip_config_name                = string
    private_ip_meth               = string
    subnet_name                   = string
    vnet_name                     = string
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
