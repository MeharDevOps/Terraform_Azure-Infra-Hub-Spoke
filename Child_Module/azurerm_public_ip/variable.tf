
variable "public_ip" {
  type = map(object({
    pip_name                   = string
    rg_name                    = string
    location                   = string
    allocation_method           = string
    sku                        = optional(string)
    idle_timeout_in_minutes     = optional(number)
    domain_name_label           = optional(string)
    ip_version                  = optional(string)
    zones                       = optional(list(string))
    ddos_protection_mode        = optional(string)
    ddos_protection_plan_id     = optional(string)
    reverse_fqdn                = optional(string)
    tags                        = optional(map(string))
  }))
}
