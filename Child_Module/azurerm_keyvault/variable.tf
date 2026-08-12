

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

