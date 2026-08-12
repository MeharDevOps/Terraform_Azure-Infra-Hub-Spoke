
variable "subnet" {
  type = map(object({
    subnet_name                           = string
    vnet_name                             = string
    rg_name                               = string
    address_prefixes                      = list(string)
    service_endpoints                     = optional(list(string))
    private_endpoint_network_policies     = optional(string)
    private_link_service_network_policies = optional(string)
    delegation                            = optional(list(object({
      name = string
      service_delegation = object({
        name    = string
        actions = list(string)
      })
    })))
  }))
}
