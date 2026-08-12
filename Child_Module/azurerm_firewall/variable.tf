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
      mic_name             = string
      subnet_id            = string
      public_ip_address_id = string
    })))

    virtual_hub = optional(list(object({
      virtual_hub_id  = string
      public_ip_count = optional(number)
    })))
  }))
}