
#################################
# Variable Definition
#################################
variable "azure_bastion" {
  description = "Bastion setup configuration"
  type = map(object({
    bastion_name        = string
    location            = string
    rg_name             = string
    vnet_name           = string
    bastion_subnetname  = string
    address_prefixes    = list(string)
    pip_name            = string
    tags                = optional(map(string))
  }))
}
