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
