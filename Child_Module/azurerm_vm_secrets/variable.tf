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